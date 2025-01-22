// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./ISuiBridge.sol";

contract MockSuiBridge is ISuiBridge {

    event BurnOnSuiCalled(address indexed from, uint256 amount);
    event MintOnSuiCalled(address indexed to, uint256 amount);


    function burnOnSui(address from, uint256 amount) external override {
        emit BurnOnSuiCalled(from, amount);
    }

    function mintOnSui(address to, uint256 amount) external override {
        emit MintOnSuiCalled(to, amount);
    }
}
