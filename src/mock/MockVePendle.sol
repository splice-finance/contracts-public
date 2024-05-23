// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract MockVePendle {

    function totalSupplyAndBalanceCurrent(address /*user*/) external pure returns (uint128, uint128) {
        return (0, 0);
    }
}
