// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract NexusToken is ERC20, Ownable {
    mapping(address => uint256) private _lockedBalances;
    event Locked(address indexed user, uint256 amount);
    event Unlocked(address indexed user, uint256 amount);



    constructor(address initialOwner) ERC20("Nexus Token", "NEX") Ownable(initialOwner) {}

    /// /// /// /// /// ///
    /// minting tokens ///
    /// /// /// /// /// ///
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /// /// /// /// /// ///
    /// burning tokens ///
    /// /// /// /// /// ///
    function burn(uint256 amount) public onlyOwner {
        _burn(msg.sender, amount);
    }

    /// /// /// /// /// ///
    /// locking tokens ///
    /// /// /// /// /// ///
    function lock(address user, uint256 amount) public onlyOwner {
        require(balanceOf(user) >= amount, "Insufficient balance");
        _transfer(user, address(this), amount);
        _lockedBalances[user] += amount;
        emit Locked(user, amount);
    }

    /// /// /// /// /// ///
    /// unlocking tokens ///
    /// /// /// /// /// ///
    function unlock(address user, uint256 amount) public onlyOwner {
        require(_lockedBalances[user] >= amount, "Insufficient locked balance");
        _lockedBalances[user] -= amount;
        _transfer(address(this), user, amount);
        emit Unlocked(user, amount);
    }

    /// /// /// /// /// ///
    /// checking locked ///
    /// /// /// /// /// ///
    function lockedBalanceOf(address user) public view returns (uint256) {
        return _lockedBalances[user];
    }
}
