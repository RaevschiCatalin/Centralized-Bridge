
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NexusToken.sol";

contract NexusTokenTest is Test {
    NexusToken token;
    address deployer = address(this);
    address user = address(0x123);

    function setUp() public {
        token = new NexusToken();
    }

    function testMint() public {
        token.mint(user, 1000);
        assertEq(token.balanceOf(user), 1000);
    }

    function testBurn() public {
        token.mint(user, 1000);
        vm.prank(user);
        token.burn(500);
        assertEq(token.balanceOf(user), 500);
    }

    function testBurnFrom() public {
        token.mint(user, 1000);
        vm.prank(user);
        token.approve(deployer, 500);
        token.burnFrom(user, 500);
        assertEq(token.balanceOf(user), 500);
    }

    function testOnlyOwnerCanMint() public {
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(user, 1000);
    }
}
