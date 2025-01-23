// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol"; // Import console for logging
import "../src/SuiEthBridge.sol";
import "../src/NexusToken.sol";

contract Deploy is Script {
    function run() external {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);


        vm.startBroadcast(deployerPrivateKey);


        NexusToken token = new NexusToken("Nexus", "NEX", 18, deployerAddress);
        console.log("NexusToken deployed at:", address(token));


        address suiBridge = 0xe3a4554b664868071046db4e2212093debe97dca910cbce5105ea7e58421f079;


        SuiEthBridge bridge = new SuiEthBridge(address(token), suiBridge);
        console.log("SuiEthBridge deployed at:", address(bridge));

        vm.stopBroadcast();
    }
}