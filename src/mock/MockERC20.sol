// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {

    constructor() ERC20("", "") {}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}