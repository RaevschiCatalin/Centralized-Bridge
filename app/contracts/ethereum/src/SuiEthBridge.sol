pragma solidity ^0.8.28;

import "./NexusToken.sol";

interface ISuiBridge {
    function burnOnSui(address from, uint256 amount) external;
    function mintOnSui(address to, uint256 amount) external;
}

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


    function bridgeTokensFromSui(address from, uint256 amount) external onlyOwner {
        ISuiBridge(suiBridge).burnOnSui(from, amount);
        nexusToken.mint(from, amount);
    }


    function bridgeTokensToSui(address to, uint256 amount) external {
        nexusToken.burn(amount);
        ISuiBridge(suiBridge).mintOnSui(to, amount);
    }
}
