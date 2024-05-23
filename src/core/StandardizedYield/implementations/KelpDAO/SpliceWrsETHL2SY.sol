// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../SYBase.sol";
import "../../../../interfaces/IPExchangeRateOracle.sol";

contract SpliceWrsETHL2SY is SYBase {
    using PMath for uint256;

    address public immutable wrsETH;

    address public exchangeRateOracle;

    event SetNewExchangeRateOracle(address oracle);

    constructor(
        address _wrsETH,
        address _exchangeRateOracle
    ) SYBase("SY Kelp wrsETH", "SY-wrsETH", _wrsETH) {
        wrsETH = _wrsETH;
        exchangeRateOracle = _exchangeRateOracle;
    }

    /*///////////////////////////////////////////////////////////////
                    DEPOSIT/REDEEM USING BASE TOKENS
    //////////////////////////////////////////////////////////////*/

    function _deposit(address /*tokenIn*/, uint256 amountDeposited) internal virtual override returns (uint256) {
        return amountDeposited;
    }

    function _redeem(
        address receiver,
        address /*tokenOut*/,
        uint256 amountSharesToRedeem
    ) internal virtual override returns (uint256) {
        _transferOut(wrsETH, receiver, amountSharesToRedeem);
        return amountSharesToRedeem;
    }

    /*///////////////////////////////////////////////////////////////
                               EXCHANGE-RATE
    //////////////////////////////////////////////////////////////*/
    function exchangeRate() public view virtual override returns (uint256) {
        return IPExchangeRateOracle(exchangeRateOracle).getExchangeRate();
    }

    function setExchangeRateOracle(address newOracle) external onlyOwner {
        exchangeRateOracle = newOracle;
        emit SetNewExchangeRateOracle(newOracle);
    }

    /*///////////////////////////////////////////////////////////////
                MISC FUNCTIONS FOR METADATA
    //////////////////////////////////////////////////////////////*/

    function _previewDeposit(address /*tokenIn*/, uint256 amountTokenToDeposit) internal view override returns (uint256) {
        return amountTokenToDeposit;
    }

    function _previewRedeem(
        address /*tokenOut*/,
        uint256 amountSharesToRedeem
    ) internal pure override returns (uint256 /*amountTokenOut*/) {
        return amountSharesToRedeem;
    }

    function getTokensIn() public view virtual override returns (address[] memory) {
        return ArrayLib.create(wrsETH);
    }

    function getTokensOut() public view virtual override returns (address[] memory) {
        return ArrayLib.create(wrsETH);
    }

    function isValidTokenIn(address token) public view virtual override returns (bool) {
        return token == wrsETH;
    }

    function isValidTokenOut(address token) public view virtual override returns (bool) {
        return token == wrsETH;
    }

    function assetInfo() external view returns (AssetType assetType, address assetAddress, uint8 assetDecimals) {
        return (AssetType.TOKEN, wrsETH, 18);
    }
}
