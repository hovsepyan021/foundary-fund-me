// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";

contract FundMeTest is Test {
    uint256 number = 0;

    function setUp() external {
        number = 1;
    }

    function testDemo() public {
        console.log(number);
        console.log("hello");
        assertEq(1, number);
    }
}