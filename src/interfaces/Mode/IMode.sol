// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

interface IMode {
	function register(address _recipient) external returns (uint256 tokenId);
}