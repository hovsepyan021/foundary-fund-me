// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr('user');
    uint256 AMOUNT_TO_SEND = 0.1 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 2 ether);
    }

    function testMinimumDollarIsDive() public {
        assertEq(5e18, fundMe.MINIMUM_USD());
    }

    function testOwner() public {
        assertEq(msg.sender, fundMe.i_owner());
    }

    function testPriceFeedVersionIsCorrect() public {
        assertEq(4, fundMe.getVersion());
    }

    function testFundFailedIfNotEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundHappyPath() public {
        vm.prank(USER);
        fundMe.fund{value: AMOUNT_TO_SEND}();
        assertEq(AMOUNT_TO_SEND, fundMe.getAddressToAmountFunded(USER));
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdraw() public {
        vm.prank(msg.sender);
        fundMe.withdraw();
    }

    function testFundAndWithdraw() public {
        uint256 initialGas = gasleft();
        uint256 initialBalance = msg.sender.balance;

        uint160 funders = 10;
        for(uint160 i = 1; i < funders; i++) {
            hoax(address(i), 10 ether);
            fundMe.fund{value: 1 ether}();
        }
        vm.prank(msg.sender);
        fundMe.withdraw();
        assertEq(9 ether, msg.sender.balance - initialBalance);
        assertEq(0, (initialGas - gasleft()) * tx.gasprice);
    }

    function testFundAndCheapWithdraw() public {
        uint256 initialGas = gasleft();
        uint256 initialBalance = msg.sender.balance;

        uint160 funders = 10;
        for(uint160 i = 1; i < funders; i++) {
            hoax(address(i), 10 ether);
            fundMe.fund{value: 1 ether}();
        }
        vm.prank(msg.sender);
        fundMe.cheaperWithdraw();
        assertEq(9 ether, msg.sender.balance - initialBalance);
        assertEq(0, (initialGas - gasleft()) * tx.gasprice);
    }

    function testFundAndWithdrawWithGasPrice() public {
        vm.txGasPrice(0.001 ether);
        uint256 initialGas = gasleft();
        uint256 initialBalance = msg.sender.balance;

        uint160 funders = 10;
        for(uint160 i = 1; i < funders; i++) {
            hoax(address(i), 10 ether);
            fundMe.fund{value: 1 ether}();
        }
        vm.prank(msg.sender);
        fundMe.withdraw();
        assertEq(9 ether, msg.sender.balance - initialBalance);
        assertNotEq(0, (initialGas - gasleft()) * tx.gasprice);
    }
}