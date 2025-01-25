//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Token} from "../mocks/Token.sol";
import {Savings} from "../../src/Savings.sol";
import {Handler} from "./Handler.t.sol";

contract SavingInvariantTest is StdInvariant, Test {
    Token token;
    Savings savings;
    Handler handler;
    address user = makeAddr("user");

    uint256 public constant MAX_DEPOSIT_AMOUNT = 1_000_000e18;
    // @notice MIN_DEPOSIT_AMOUNT is the minimum amount that can be deposited into this contract
    uint256 public constant MIN_DEPOSIT_AMOUNT = 1e18;

    function setUp() public {
        token = new Token();
        savings = new Savings(address(token));
        handler = new Handler(savings, token);
        token.mint(user, MIN_DEPOSIT_AMOUNT);
        vm.prank(user);
        token.approve(address(savings), type(uint256).max); // User approves Savings contract to spend tokens
        // handler.deposit(MIN_DEPOSIT_AMOUNT);
        vm.stopPrank();

         bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = handler.deposit.selector;
        targetSelector(FuzzSelector({ addr: address(handler), selectors: selectors }));

        targetContract(address(handler));

        vm.warp(block.timestamp + 300 days);
    }

    // Invariant: Total deposited should not exceed MAX_DEPOSIT_AMOUNT
    function invariant_totalDeposited() public {
        console.log("user balance",  token.balanceOf(user));
        assertEq(savings.totalDeposited(), token.balanceOf(user));
    }
}







