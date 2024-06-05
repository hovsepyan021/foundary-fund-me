// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsDive() public {
        assertEq(5e18, fundMe.MINIMUM_USD());
    }

    function testOwner() public {
        assertEq(address(this), fundMe.i_owner());
    }
}