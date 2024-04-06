// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    FundFundMe fundFundMe;
    WithdrawFundMe withdrawFundMe;
    HelperConfig helperConfig;

    address USER = makeAddr("user");
    uint256 constant AMOUNT_FUNDED = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10e18;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.run();
        fundFundMe = new FundFundMe();
        withdrawFundMe = new WithdrawFundMe();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteraction() public {
        fundFundMe.fundFundMe(address(fundMe));
        assertEq(AMOUNT_FUNDED, address(fundMe).balance);
    }

    function testUserCanWithdrawInteraction() public {
        fundFundMe.fundFundMe(address(fundMe));
        assertEq(AMOUNT_FUNDED, address(fundMe).balance);
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assertEq(0, address(fundMe).balance);
    }
}
