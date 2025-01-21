pragma solidity ^0.8.28;

import "./NexusToken.sol";

interface ISuiBridge {
    function mintOnSui(address to, uint256 amount) external;
    function burnOnSui(address from, uint256 amount) external;
}

contract EthSuiBridge {
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

    function bridgeTokensToSui(uint256 amount) external {
        nexusToken.burn(amount);
        ISuiBridge(suiBridge).mintOnSui(msg.sender, amount);
    }

    function bridgeTokensToEthereum(address to, uint256 amount) external onlyOwner {
        ISuiBridge(suiBridge).burnOnSui(to, amount);
        nexusToken.mint(to, amount);
    }
}
