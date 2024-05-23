// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../SYBase.sol";
import "../../../../interfaces/IPExchangeRateOracle.sol";

contract SpliceWeETHL2SY is SYBase {
    using PMath for uint256;

    address public immutable weETH;

    address public exchangeRateOracle;

    event SetNewExchangeRateOracle(address oracle);

    constructor(
        address _weETH,
        address _exchangeRateOracle
    ) SYBase("SY ether.fi weETH", "SY-weETH", _weETH) {
        weETH = _weETH;
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
        _transferOut(weETH, receiver, amountSharesToRedeem);
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
        return ArrayLib.create(weETH);
    }

    function getTokensOut() public view virtual override returns (address[] memory) {
        return ArrayLib.create(weETH);
    }

    function isValidTokenIn(address token) public view virtual override returns (bool) {
        return token == weETH;
    }

    function isValidTokenOut(address token) public view virtual override returns (bool) {
        return token == weETH;
    }

    function assetInfo() external view returns (AssetType assetType, address assetAddress, uint8 assetDecimals) {
        return (AssetType.TOKEN, weETH, 18);
    }
}
