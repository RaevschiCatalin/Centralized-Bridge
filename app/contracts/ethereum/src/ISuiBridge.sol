// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface ISuiBridge {
    function mintOnSui(address to, uint256 amount) external;
    function burnOnSui(address from, uint256 amount) external;
}
