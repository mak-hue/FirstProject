// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {TinySender} from "../src/FirstProject.sol";

contract TinySenderTest is Test {
    TinySender tinySender;

    address sender = address(1);
    address recipient = address(2);

    uint256 constant AMOUNT = 0.0001 ether;

    function setUp() public {
        tinySender = new TinySender();

        // Give sender some ETH
        vm.deal(sender, 1 ether);
    }

    // ✅ Test successful send
    function testSendTinyETH() public {
        uint256 recipientBalanceBefore = recipient.balance;

        vm.prank(sender);
        tinySender.sendTinyETH{value: AMOUNT}(payable(recipient));

        assertEq(recipient.balance, recipientBalanceBefore + AMOUNT);
    }

    // ✅ Test refund logic
    function testRefundExcessETH() public {
        uint256 excess = 0.0002 ether;

        uint256 senderBalanceBefore = sender.balance;

        vm.prank(sender);
        tinySender.sendTinyETH{value: excess}(payable(recipient));

        // Sender should only lose AMOUNT
        assertEq(sender.balance, senderBalanceBefore - AMOUNT);
    }

    // ❌ Test revert if insufficient ETH
    function testRevertIfInsufficientETH() public {
        vm.prank(sender);

        vm.expectRevert(TinySender.InsufficientETH.selector);
        tinySender.sendTinyETH{value: 1}(payable(recipient)); // too small
    }

    // ✅ Test event emission
    function testEmitEvent() public {
        vm.prank(sender);

        vm.expectEmit(true, true, false, true);
        emit TinySender.TinySent(sender, recipient, AMOUNT);

        tinySender.sendTinyETH{value: AMOUNT}(payable(recipient));
    }
}