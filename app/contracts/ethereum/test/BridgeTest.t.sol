// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../src/SuiEthBridge.sol";
import "forge-std/Test.sol";
import "../src/NexusToken.sol";

contract MockSuiBridge is ISuiBridge {
    event BurnOnSuiCalled(address indexed from, uint256 amount);
    event MintOnSuiCalled(address indexed to, uint256 amount);

    function burnOnSui(address from, uint256 amount) external override {
        emit BurnOnSuiCalled(from, amount);
    }

    function mintOnSui(address to, uint256 amount) external override {
        emit MintOnSuiCalled(to, amount);
    }
}

contract SuiEthBridgeTest is Test {
    SuiEthBridge public bridge;
    NexusToken public nexusToken;
    MockSuiBridge public mockSuiBridge;
    address public user;
    address public owner;

    function setUp() public {
        user = address(0x123);
        owner = address(this);

        mockSuiBridge = new MockSuiBridge();
        nexusToken = new NexusToken("NexusToken", "NXT", 18, owner);
        bridge = new SuiEthBridge(address(nexusToken), address(mockSuiBridge));

        assertEq(bridge.owner(), owner, "Owner mismatch");
        console.log("Owner set to: ", owner);
    }

    function testBridgeTokensFromEth() public {
        uint256 amount = 1000;

        vm.prank(owner);
        bridge.bridgeTokensFromEth(user, amount);
        assertEq(nexusToken.balanceOf(user), amount, "User balance mismatch after bridging from Ethereum.");
        console.log("User balance after bridging from Ethereum: ", nexusToken.balanceOf(user));

        uint256 userBalance = nexusToken.balanceOf(user);
        assertEq(userBalance, amount, "User balance assertion failed after bridging from Ethereum");
    }

    function testBridgeTokensFromSui() public {
        uint256 amount = 1000;

        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.MintOnSuiCalled(user, amount);

        vm.prank(owner);
        bridge.bridgeTokensFromSui(user, amount);
        assertEq(nexusToken.balanceOf(user), amount, "User balance mismatch after bridging from Sui.");
        console.log("User balance after bridging from Sui: ", nexusToken.balanceOf(user));

        uint256 userBalance = nexusToken.balanceOf(user);
        assertEq(userBalance, amount, "User balance assertion failed after bridging from Sui");
    }

    function testEvents() public {
        uint256 amount = 1000;

        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.MintOnSuiCalled(user, amount);

        vm.prank(owner);
        bridge.bridgeTokensFromSui(user, amount);
        assertEq(nexusToken.balanceOf(user), amount, "User balance mismatch after bridging from Sui in events");

        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.BurnOnSuiCalled(user, amount);

        vm.prank(user);
        bridge.bridgeTokensToSui(user, amount);
        assertEq(nexusToken.balanceOf(user), 0, "User balance mismatch after bridging to Sui in events");
    }
}
