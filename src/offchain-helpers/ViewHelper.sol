// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "../interfaces/IPMarket.sol";
import "../core/Market/MarketMathCore.sol";
import "../core/libraries/math/PMath.sol";

contract ViewHelper {
    using MarketMathCore for MarketState;
    using PMath for int256;
    using PMath for uint256;

    int256 internal constant MINIMUM_LIQUIDITY = 10 ** 3;

    function _readMarket(address market) internal view returns (MarketState memory) {
        return IPMarket(market).readState(address(this));
    }

    function addLiquidity(address _market, int256 _syDesired, int256 _ptDesired) external view returns (uint256, uint256, uint256) {
        MarketState memory market = _readMarket(_market);

        int256 lpToAccount = 0;
        int256 ptUsed = 0;
        int256 syUsed = 0;

        if (market.totalLp == 0) {
            lpToAccount = PMath.sqrt((_syDesired * _ptDesired).Uint()).Int() - MINIMUM_LIQUIDITY;
            syUsed = _syDesired;
            ptUsed = _ptDesired;
        } else {
            int256 netLpByPt = (_ptDesired * market.totalLp) / market.totalPt;
            int256 netLpBySy = (_syDesired * market.totalLp) / market.totalSy;

            if (netLpByPt < netLpBySy) {
                lpToAccount = netLpByPt;
                ptUsed = _ptDesired;
                syUsed = (market.totalSy * lpToAccount) / market.totalLp;
            } else {
                lpToAccount = netLpBySy;
                syUsed = _syDesired;
                ptUsed = (market.totalPt * lpToAccount) / market.totalLp;
            }
        }


        return (lpToAccount.Uint(), ptUsed.Uint(), syUsed.Uint());
    }

    function removeLiquidity(address _market, int256 _lpToRemove) external view returns (uint256, uint256) {
        MarketState memory market = _readMarket(_market);

        int256 netSyToAccount = (_lpToRemove * market.totalSy) / market.totalLp;
        int256 netPtToAccount = (_lpToRemove * market.totalPt) / market.totalLp;

        return (netSyToAccount.Uint(), netPtToAccount.Uint());
    }
}
