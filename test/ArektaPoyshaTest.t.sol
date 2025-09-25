// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {DeployArektaPoysha} from "../script/DeployArektaPoysha.s.sol";
import {ArektaPoysha} from "../src/ArektaPoysha.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract ArektaPoyshaTest is StdCheats, Test {
    ArektaPoysha public arektaPoysha;
    DeployArektaPoysha public deployer;
    address alice = address(1);
    address bob = address(2);

    function setUp() public {
        deployer = new DeployArektaPoysha();
        arektaPoysha = deployer.run();

        // label addresses in logs
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
    }

    // ✅ Already written
    function testInitialSupply() public view {
        assertEq(arektaPoysha.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        // Casting to MintableToken interface tries to call a non-existent mint() function
        MintableToken(address(arektaPoysha)).mint(address(this), 1);
    }

    // ✅ Transfers
    // function testTransferUpdatesBalances() public {
    //     uint256 amount = 100e18;
    //     arektaPoysha.transfer(alice, amount);
    //     assertEq(arektaPoysha.balanceOf(alice), amount);
    //     assertEq(
    //         arektaPoysha.balanceOf(address(this)),
    //         deployer.INITIAL_SUPPLY() - amount
    //     );
    // }

    function testTransferFailsIfInsufficientBalance() public {
        vm.startPrank(alice); // Alice has 0 tokens
        vm.expectRevert();
        arektaPoysha.transfer(bob, 10);
        vm.stopPrank();
    }

    // ✅ Allowances
    function testApproveSetsAllowance() public {
        uint256 amount = 50e18;
        arektaPoysha.approve(alice, amount);
        assertEq(arektaPoysha.allowance(address(this), alice), amount);
    }

    // function testTransferFromWorksWithAllowance() public {
    //     uint256 amount = 20e18;

    //     // Give Alice allowance
    //     arektaPoysha.approve(alice, amount);

    //     // Alice spends from my account
    //     vm.prank(alice);
    //     arektaPoysha.transferFrom(address(this), bob, amount);

    //     assertEq(arektaPoysha.balanceOf(bob), amount);
    //     assertEq(arektaPoysha.allowance(address(this), alice), 0); // auto-decreased
    // }

    function testTransferFromFailsWithoutAllowance() public {
        uint256 amount = 10e18;
        vm.prank(alice);
        vm.expectRevert();
        arektaPoysha.transferFrom(address(this), bob, amount);
    }

    // ✅ Increase/Decrease allowance helpers
    // function testIncreaseDecreaseAllowance() public {
    //     arektaPoysha.approve(alice, 100);
    //     arektaPoysha.increaseAllowance(alice, 50);
    //     assertEq(arektaPoysha.allowance(address(this), alice), 150);

    //     arektaPoysha.decreaseAllowance(alice, 30);
    //     assertEq(arektaPoysha.allowance(address(this), alice), 120);
    // }

    // ✅ Events
    // function testTransferEmitsEvent() public {
    //     vm.expectEmit(true, true, false, true);
    //     emit Transfer(msg.sender, alice, 1e18);
    //     arektaPoysha.transfer(alice, 1e18);
    // }

    function testApprovalEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Approval(address(this), alice, 123);
        arektaPoysha.approve(alice, 123);
    }

    // ✅ Metadata
    function testTokenMetadata() public view {
        assertEq(arektaPoysha.name(), "Arekta Poysha");
        assertEq(arektaPoysha.symbol(), "APS");
        assertEq(arektaPoysha.decimals(), 18); // default from OZ
    }

    // Needed so expectEmit knows what events look like
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
