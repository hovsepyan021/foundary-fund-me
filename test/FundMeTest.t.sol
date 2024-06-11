// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        deployFundMe.run();
    }

    function testMinimumDollarIsDive() public {
        assertEq(5e18, fundMe.MINIMUM_USD());
    }

    function testOwner() public {
        assertEq(address(this), fundMe.i_owner());
    }

    function testPriceFeedVersionIsCorrect() public {
        assertEq(4, fundMe.getVersion());
    }
}