// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ArektaPoysha is ERC20 {
    constructor(uint256 initialSupply) ERC20("Arekta Poysha", "APS") {
        _mint(msg.sender, initialSupply);
    }

    function name() public view override returns (string memory) {
        return super.name();
    }
}
