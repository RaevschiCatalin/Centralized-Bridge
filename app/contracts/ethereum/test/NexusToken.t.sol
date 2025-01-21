pragma solidity ^0.8.28;

import "../src/NexusToken.sol";
import "forge-std/Test.sol";

contract NexusTokenTest is Test {
    NexusToken nexusToken;
    address owner = address(this);
    address user = address(0x123);

    function setUp() public {

        nexusToken = new NexusToken(
            "NexusToken",
            "NXT",
            18,
            owner
        );
    }



    function testMint() public {
        uint256 mintAmount = 100 * 10 ** nexusToken.decimals();


        nexusToken.mint(user, mintAmount);


        assertEq(nexusToken.balanceOf(user), mintAmount);


        uint256 expectedSupply = 1000000000 * 10 ** nexusToken.decimals() + mintAmount;
        assertEq(nexusToken.totalSupply(), expectedSupply);
    }

    function testInitialSupply() public {
        uint256 expectedSupply = 1000 * 10 ** 18;
        assertEq(nexusToken.totalSupply(), expectedSupply);
    }

    function testMintRevertIfNotOwner() public {
        vm.startPrank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        nexusToken.mint(user, 1000);
        vm.stopPrank();
    }



    function testBurn() public {
        uint256 burnAmount = 50 * 10 ** nexusToken.decimals();


        nexusToken.burn(burnAmount);


        uint256 expectedBalance = 1000000000 * 10 ** nexusToken.decimals() - burnAmount;
        assertEq(nexusToken.balanceOf(owner), expectedBalance);


        uint256 expectedSupply = 1000000000 * 10 ** nexusToken.decimals() - burnAmount;
        assertEq(nexusToken.totalSupply(), expectedSupply);
    }

    function testBridgeMint() public {
        uint256 mintAmount = 200 * 10 ** nexusToken.decimals();


        nexusToken.bridgeMint(user, mintAmount);


        assertEq(nexusToken.balanceOf(user), mintAmount);


        uint256 expectedSupply = 1000000000 * 10 ** nexusToken.decimals() + mintAmount;
        assertEq(nexusToken.totalSupply(), expectedSupply);
    }

    function testBurnEmitEvent() public {
        uint256 burnAmount = 30 * 10 ** nexusToken.decimals();


        vm.expectEmit(true, true, true, true);
        emit NexusToken.Bridged(owner, burnAmount, block.timestamp);


        nexusToken.burn(burnAmount);
    }
}
