// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../src/SuiEthBridge.sol";
import "forge-std/Test.sol";
import "../src/NexusToken.sol";

contract SuiEthBridgeTest is Test {
    SuiEthBridge public bridge;
    NexusToken public nexusToken;
    address public mockSuiBridge;
    address public user;

    function setUp() public {
        user = address(0x123);
        mockSuiBridge = address(0x456);


        nexusToken = new NexusToken(
            "NexusToken",
            "NXT",
            18,
            address(this)
        );


        bridge = new SuiEthBridge(address(nexusToken), mockSuiBridge);
    }

    function testBridgeTokensFromSui() public {
        uint256 amount = 1000;


        vm.startPrank(address(this));
        bridge.bridgeTokensFromSui(user, amount);
        vm.stopPrank();


        assertEq(nexusToken.balanceOf(user), amount);
    }

    function testBridgeTokensToSui() public {
        uint256 amount = 500;


        vm.startPrank(address(this));
        nexusToken.mint(user, amount);
        vm.stopPrank();


        vm.prank(address(this));
        bridge.bridgeTokensToSui(user, amount);


        assertEq(nexusToken.balanceOf(user), 0);
    }

}
