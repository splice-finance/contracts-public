// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PendleRouterV3.sol";
import "../interfaces/Mode/IMode.sol";

contract PendleRouterV3__Mode is PendleRouterV3, Ownable {
	// Mode mainnet SFS Contract
	IMode public constant MODE = IMode(0x8680CEaBcb9b56913c519c069Add6Bc3494B7020);

    constructor(
        address _ACTION_ADD_REMOVE_LIQ,
        address _ACTION_SWAP_PT,
        address _ACTION_SWAP_YT,
        address _ACTION_MISC,
        address _ACTION_CALLBACK,
        address _recipient
    ) PendleRouterV3(
        _ACTION_ADD_REMOVE_LIQ,
        _ACTION_SWAP_PT,
        _ACTION_SWAP_YT,
        _ACTION_MISC,
        _ACTION_CALLBACK
    ) {
        MODE.register(_recipient);
    }
}
