// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NexusToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NexusTokenTest is Test {
    NexusToken private nexusToken;
    address private owner;
    address private user;

    event Locked(address indexed user, uint256 amount);
    event Unlocked(address indexed user, uint256 amount);


    function setUp() public {
        owner = address(this);
        user = address(0x123);
        nexusToken = new NexusToken(owner);
    }

    function testMint() public {
        uint256 amount = 1000;
        nexusToken.mint(user, amount);
        assertEq(nexusToken.balanceOf(user), amount);
    }

    function testBurn() public {
        uint256 mintAmount = 1000;
        uint256 burnAmount = 500;
        nexusToken.mint(owner, mintAmount);
        nexusToken.burn(burnAmount);
        assertEq(nexusToken.balanceOf(owner), mintAmount - burnAmount);
    }

    function testLock() public {
        uint256 mintAmount = 1000;
        uint256 lockAmount = 500;
        nexusToken.mint(user, mintAmount);

        vm.expectEmit(true, true, true, true);
        emit Locked(user, lockAmount);


        nexusToken.lock(user, lockAmount);
        assertEq(nexusToken.lockedBalanceOf(user), lockAmount);
        assertEq(nexusToken.balanceOf(user), mintAmount - lockAmount);
    }

    function testUnlock() public {
        uint256 mintAmount = 1000;
        uint256 lockAmount = 500;
        uint256 unlockAmount = 300;
        nexusToken.mint(user, mintAmount);
        nexusToken.lock(user, lockAmount);

        vm.expectEmit(true, true, true, true);
        emit Unlocked(user, unlockAmount);

        nexusToken.unlock(user, unlockAmount);
        assertEq(nexusToken.lockedBalanceOf(user), lockAmount - unlockAmount);
        assertEq(nexusToken.balanceOf(user), mintAmount - lockAmount + unlockAmount);
    }

    function testOnlyOwnerCanMint() public {
        uint256 amount = 1000;
        vm.prank(address(0x456));
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, address(0x456)));
        nexusToken.mint(user, amount);
    }

    function testOnlyOwnerCanBurn() public {
        uint256 amount = 1000;
        nexusToken.mint(owner, amount);
        vm.prank(address(0x456));
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, address(0x456)));
        nexusToken.burn(amount);
    }

    function testOnlyOwnerCanLock() public {
        uint256 amount = 1000;
        nexusToken.mint(user, amount);
        vm.prank(address(0x456));
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, address(0x456)));
        nexusToken.lock(user, amount);
    }

    function testOnlyOwnerCanUnlock() public {
        uint256 amount = 1000;
        nexusToken.mint(user, amount);
        nexusToken.lock(user, amount);
        vm.prank(address(0x456));
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, address(0x456)));
        nexusToken.unlock(user, amount);
    }
}
