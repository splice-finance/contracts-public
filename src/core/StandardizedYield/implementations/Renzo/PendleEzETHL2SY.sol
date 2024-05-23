// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../SYBase.sol";
import "../../../../interfaces/IPExchangeRateOracle.sol";

contract PendleEzETHL2SY is SYBase {
    using PMath for uint256;

    address public immutable ezETH;

    address public exchangeRateOracle;

    event SetNewExchangeRateOracle(address oracle);

    constructor(
        address _ezETH,
        address _exchangeRateOracle
    ) SYBase("SY Renzo ezETH", "SY-ezETH", _ezETH) {
        ezETH = _ezETH;
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
        _transferOut(ezETH, receiver, amountSharesToRedeem);
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
        return ArrayLib.create(ezETH);
    }

    function getTokensOut() public view virtual override returns (address[] memory) {
        return ArrayLib.create(ezETH);
    }

    function isValidTokenIn(address token) public view virtual override returns (bool) {
        return token == ezETH;
    }

    function isValidTokenOut(address token) public view virtual override returns (bool) {
        return token == ezETH;
    }

    function assetInfo() external view returns (AssetType assetType, address assetAddress, uint8 assetDecimals) {
        return (AssetType.TOKEN, ezETH, 18);
    }
}
