// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";
import {FundMe} from "../../src/FundMe.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract PriceConvertTest is Test {
    FundMe public fundMe;
    HelperConfig public helperConfig;
    address public priceFeed;

    function setUp() public {
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.run();
        priceFeed = helperConfig.activeNetworkConfig();
    }

    function testCanGetPriceInCorrectFormat() public {
        uint256 ethAmount = 2;
        (, int256 price,,,) = MockV3Aggregator(priceFeed).latestRoundData();
        uint256 expectedPrice = (uint256(price * 10000000000) * ethAmount) / 1000000000000000000;
        uint256 conversionRate = PriceConverter.getConversionRate(ethAmount, MockV3Aggregator(priceFeed));
        assertEq(expectedPrice, conversionRate);
    }
}
