// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig helperConfig;

    address USER = makeAddr("user");
    uint256 constant AMOUNT_FUNDED = 1e18;
    uint256 constant NOT_ENOUGH_AMOUNT_FUNDED = 1e10;
    uint256 constant STARTING_BALANCE = 10e18;
    uint256 constant GAS_PRICE = 1;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    // Modifiers

    modifier funded() {
        vm.prank(USER); // Tell us that the next TX will be sent by the USER
        fundMe.fund{value: AMOUNT_FUNDED}();
        _;
    }

    function setUp() external {
        // instantiate the contract
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundMe, helperConfig) = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    // Forked Tests --> used to run tests on a simulated real environment,
    // where we can run tests with addresses outside of this system

    // Fund Tests

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(FundMe.FundMe__NotEnoughEth.selector); // expect next line to revert
        fundMe.fund{value: NOT_ENOUGH_AMOUNT_FUNDED}();
    }

    function testFundPassThrough() public funded {
        assertEq(AMOUNT_FUNDED, fundMe.getAmountFunded(USER));
        assertEq(USER, fundMe.getFunder(0));
    }

    // Withdraw Tests

    function testRevertsWithdrawIfNotOwner() public funded {
        vm.expectRevert(FundMe.FundMe__NotOwner.selector);
        vm.prank(address(2));
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE); // sets up prank and assigns some ether
            fundMe.fund{value: AMOUNT_FUNDED}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }

    // CheaperWithdraw Tests

    function testRevertsCheaperWithdrawIfNotOwner() public funded {
        vm.expectRevert(FundMe.FundMe__NotOwner.selector);
        vm.prank(address(2));
        fundMe.cheaperWithdraw();
    }

    function testWithdrawWithMultipleFunderCheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: AMOUNT_FUNDED}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }

    // View / Pure function tests

    function testMinimumDollarIsFive() public {
        assertEq(MINIMUM_USD, fundMe.getMinimumUsdRequested());
    }

    function testOwnerIsMsgSender() public {
        assertEq(msg.sender, fundMe.getOwner());
    }

    // TODO - to make this test work, we should create a node on Alchemy
    function testGetVersionIsAccurate() public {
        assertEq(4, fundMe.getVersion());
    }
}
