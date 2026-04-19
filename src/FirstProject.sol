// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TinySender {
    uint256 public constant AMOUNT = 0.0001 ether;

    error InsufficientETH();
    error TransferFailed();

    event TinySent(address indexed from, address indexed to, uint256 amount);

    function sendTinyETH(address payable recipient) external payable {
        if (msg.value < AMOUNT) revert InsufficientETH();

        // Send fixed amount to recipient
        (bool success,) = recipient.call{value: AMOUNT}("");
        if (!success) revert TransferFailed();

        // Refund extra (if any)
        uint256 excess = msg.value - AMOUNT;
        if (excess > 0) {
            (bool refundSuccess,) = msg.sender.call{value: excess}("");
            if (!refundSuccess) revert TransferFailed();
        }

        emit TinySent(msg.sender, recipient, AMOUNT);
    }
}
