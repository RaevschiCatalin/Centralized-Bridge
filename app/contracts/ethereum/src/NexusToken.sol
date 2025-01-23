pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NexusToken is ERC20, Ownable {
    event Bridged(address indexed user, uint256 amount, uint256 timestamp);

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner) {
        _mint(initialOwner, 1000 * 10 ** uint256(decimals));
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit Bridged(msg.sender, amount, block.timestamp);
    }
    function burnFrom(address account, uint256 amount) external {
        uint256 currentAllowance = allowance(account, msg.sender);
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        _approve(account, msg.sender, currentAllowance - amount);
        _burn(account, amount);
    }


    function bridgeMint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        _transferOwnership(newOwner);
    }
}
