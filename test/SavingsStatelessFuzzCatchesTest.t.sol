// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Savings} from "../../src/Savings.sol";
import {Token} from "./mocks/Token.sol";


// system level
// total deposit - total withdraw == users[balance]++
// total depost <= MAX_DEPOSIT_AMOUNT

// function level
// deposit
// each user depost >= MIN_DEPOSIT_AMOUNT
// balance of user must increase by the amount deposit after depositing

// withdraw
// each user withdraw <= user[balance]
// balance of user must reduce by the amount withdraw after withdrawal
// balance of address(this) must reduce by the amount withdraw after withdrawawl






contract SavingsStatelessFuzzCatchesTest is Test {
    Savings public savings;
    Token public token;
    address public user = makeAddr("user");

    uint256 constant MIN_DEPOSIT_AMOUNT = 1e18;
    uint256 constant MAX_DEPOSIT_AMOUNT = 1_000_000e18;

    function setUp() public {
        token = new Token();
        savings = new Savings(address(token));

        // Mint tokens to the user for testing
        token.mint(user, type(uint256).max);

        // Approve the Savings contract to spend tokens on behalf of the user
        vm.prank(user);
        token.approve(address(savings), type(uint256).max);
    }

    function testStatelessDeposit(uint256 amount) public {
       amount = bound(amount, 1e18, 10000e18);

        // Simulate the user depositing
        vm.startPrank(user);
        savings.deposit(amount);
        vm.stopPrank();

        // Check if the balance updated correctly
        assertEq(savings.balances(user), amount, "User balance should match deposited amount");

        // Check if total deposited updated correctly
        assertEq(
            savings.totalDeposited(), amount, "Total deposited should equal the amount deposited in stateless test"
        );

        // Check if tokens were transferred from the user to the contract
        assertEq(token.balanceOf(user), type(uint256).max - amount, "User should have reduced token balance");
        assertEq(token.balanceOf(address(savings)), amount, "Contract should hold the deposited tokens");
    }
}


