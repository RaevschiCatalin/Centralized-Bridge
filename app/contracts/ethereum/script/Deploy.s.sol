// script/Deploy.s.sol
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/SuiEthBridge.sol";
import "../src/NexusToken.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        address initialOwner = msg.sender;
        NexusToken token = new NexusToken("Nexus", "NEX", 18, initialOwner);
        console.log("NexusToken deployed at:", address(token));


        address suiBridge = 0x1234567890123456789012345678901234567890;
        SuiEthBridge bridge = new SuiEthBridge(address(token), suiBridge);
        console.log("SuiEthBridge deployed at:", address(bridge));

        vm.stopBroadcast();
    }
}
