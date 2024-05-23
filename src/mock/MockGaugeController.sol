// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract MockGaugeController {
    address public immutable pendle;

    constructor(address _pendle) {
        pendle = _pendle;
    }

    function redeemMarketReward() public {}

}