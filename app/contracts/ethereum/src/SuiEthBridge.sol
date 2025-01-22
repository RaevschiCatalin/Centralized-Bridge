// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./NexusToken.sol";
import "./ISuiBridge.sol";

contract SuiEthBridge {
    address public owner;
    address public suiBridge;
    NexusToken public nexusToken;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _nexusToken, address _suiBridge) {
        nexusToken = NexusToken(_nexusToken);
        suiBridge = _suiBridge;
        owner = msg.sender;
    }

    event TokensBridgedFromSui(address indexed from, uint256 amount);
    event TokensBridgedToSui(address indexed to, uint256 amount);
    event TokensBridgedFromEth(address indexed from, uint256 amount);
    event TokensBridgedToEth(address indexed to, uint256 amount);

    function bridgeTokensFromSui(address from, uint256 amount) external {
        ISuiBridge(suiBridge).burnOnSui(from, amount);
        nexusToken.bridgeMint(from, amount);
        emit TokensBridgedFromSui(from, amount);
    }

    function bridgeTokensFromEth(address to, uint256 amount) external onlyOwner {
        ISuiBridge(suiBridge).burnOnSui(to, amount);
        nexusToken.bridgeMint(to, amount);
        emit TokensBridgedFromEth(to, amount);
    }

    function bridgeTokensToSui(address to, uint256 amount) external {
        require(nexusToken.balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(nexusToken.allowance(msg.sender, address(this)) >= amount, "Allowance required");
        nexusToken.burn(amount);
        ISuiBridge(suiBridge).mintOnSui(to, amount);
        emit TokensBridgedToSui(to, amount);
    }

    function bridgeTokensToEthereum(address from, uint256 amount) external onlyOwner {
        ISuiBridge(suiBridge).burnOnSui(from, amount);
        nexusToken.bridgeMint(from, amount);
        emit TokensBridgedToEth(from, amount);
    }

}
