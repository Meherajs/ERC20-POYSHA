// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Poysha {
    constructor() {}

    mapping(address => uint256) private s_balances;

    function name() public pure returns (string memory) {
        return "Poysha";
    }

    function totalSupply() public pure returns (uint256) {
        return 1000000000 * 10 ** 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _balance
    ) public returns (bool success) {
        uint256 totBalance = balanceOf(msg.sender) + balanceOf(_to);
        require(balanceOf(msg.sender) >= _balance, "Insufficient balance");
        s_balances[msg.sender] -= _balance;
        s_balances[_to] += _balance;
        require(
            balanceOf(msg.sender) + balanceOf(_to) == totBalance,
            "Balance mismatch"
        );
        return true;
    }
}
