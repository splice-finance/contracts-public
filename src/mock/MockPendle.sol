// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "../core/erc20/PendleERC20.sol";

contract MockPendle is PendleERC20 {

    constructor() PendleERC20("", "", 18) {}
}