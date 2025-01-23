// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/SuiEthBridge.sol";
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

        // Transfer ownership of NexusToken to the bridge contract
        vm.prank(owner);
        nexusToken.transferOwnership(address(bridge));

        // Verify ownership transfer
        address newOwner = nexusToken.owner();
        assertEq(newOwner, address(bridge), "Ownership transfer failed");

        // Mint initial tokens to the bridge for testing
        nexusToken.mint(address(bridge), 10000);

        assertEq(bridge.owner(), owner, "Owner mismatch");
        console.log("Owner set to: ", owner);
    }


    function testBridgeTokensFromSui() public {
        uint256 amount = 1000;

        // Ensure the bridge has enough tokens to mint
        uint256 bridgeBalanceBefore = nexusToken.balanceOf(address(bridge));
        assertGe(bridgeBalanceBefore, amount, "Bridge does not have enough tokens");

        // Expect the MintOnSui event to be emitted
        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.MintOnSuiCalled(user, amount);

        // Impersonate the owner and bridge tokens from Sui to Ethereum
        vm.prank(owner);
        bridge.bridgeTokensFromSui(user, amount);

        // Check user balance
        uint256 userBalance = nexusToken.balanceOf(user);
        assertEq(userBalance, amount, "User balance mismatch after bridging from Sui");
        console.log("User balance after bridging from Sui: ", userBalance);
    }

    function testBridgeTokensToSui() public {
        uint256 amount = 1000;

        // Mint tokens to the user and approve the bridge to spend them
        nexusToken.mint(user, amount);
        vm.prank(user);
        nexusToken.approve(address(bridge), amount);

        // Expect the BurnOnSui event to be emitted
        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.BurnOnSuiCalled(user, amount);

        // Impersonate the user and bridge tokens from Ethereum to Sui
        vm.prank(user);
        bridge.bridgeTokensToSui(user, amount);

        // Check user balance
        uint256 userBalance = nexusToken.balanceOf(user);
        assertEq(userBalance, 0, "User balance mismatch after bridging to Sui");
        console.log("User balance after bridging to Sui: ", userBalance);
    }

    function testEvents() public {
        uint256 amount = 1000;

        // Test bridging from Sui to Ethereum
        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.MintOnSuiCalled(user, amount);

        vm.prank(owner);
        bridge.bridgeTokensFromSui(user, amount);

        // Test bridging from Ethereum to Sui
        vm.expectEmit(true, true, true, true);
        emit MockSuiBridge.BurnOnSuiCalled(user, amount);

        // Mint tokens to the user and approve the bridge to spend them
        nexusToken.mint(user, amount);
        vm.prank(user);
        nexusToken.approve(address(bridge), amount);

        vm.prank(user);
        bridge.bridgeTokensToSui(user, amount);
    }
}