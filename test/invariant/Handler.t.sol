// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
// import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Token} from "../mocks/Token.sol";
import {Savings} from "../../src/Savings.sol";

// Handler contract to manage interactions with Savings contract
contract Handler is Test {
    Savings public savings;
    Token public token;
    address public user = makeAddr("user");

    constructor(Savings _savings, Token _token) {
        savings = _savings;
        token = _token;
    }

    // // Handler for deposit function
    // function deposit(uint256 amount) external {
    //     amount = bound(amount, savings.MIN_DEPOSIT_AMOUNT(), savings.MAX_DEPOSIT_AMOUNT());

    //     // Ensure the user has tokens to deposit
    //     token.mint(user, amount);
    //     token.approve(address(savings), amount);
    //     vm.prank(user);
    //     savings.deposit(amount);
    //     vm.stopPrank();
    // }


// function deposit(uint256 amount) external {
//     amount = bound(amount, savings.MIN_DEPOSIT_AMOUNT(), savings.MAX_DEPOSIT_AMOUNT());

//     // Instead of minting new tokens, ensure the user has enough balance:
//     require(token.balanceOf(user) >= amount, "Insufficient balance");

//     // Approve and transfer from user's existing balance
//     vm.prank(user);
//     token.approve(address(savings), amount);
//     vm.stopPrank();

//     vm.prank(user);
//     savings.deposit(amount);
//     vm.stopPrank();
// }


function deposit(uint256 amount) external {
    uint256 userBalance = token.balanceOf(user);
    amount = bound(amount, savings.MIN_DEPOSIT_AMOUNT(), userBalance);
    
    console.log("Bound result", amount);
    
    vm.prank(user);
    token.approve(address(savings), amount);
    vm.stopPrank();

    vm.prank(user);
    savings.deposit(amount);
    vm.stopPrank();
}
       // // Handler for withdraw function
    // function withdraw(uint256 amount, uint256 seed) external {
    //     // Use the same user address generation logic for consistency
    //     address user = address(uint160(uint256(keccak256(abi.encodePacked("user", seed)))));
    //     uint256 balance = savings.balances(user);
    //     amount = bound(amount, 0, balance);
    //     vm.prank(user);
    //     savings.withdraw(amount, user);
    // }

    // // Handler for getInterestPerAnnum function
    // function getInterest(uint256 seed) external {
    //     address user = address(uint160(uint256(keccak256(abi.encodePacked("user", seed)))));
    //     vm.warp(block.timestamp + 366 days); // Move time forward by more than a year
    //     vm.prank(user);
    //     savings.getInterestPerAnnum();
    // }

 
}
