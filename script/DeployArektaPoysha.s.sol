// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ArektaPoysha.sol";

contract DeployArektaPoysha is Script {
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    function run() external returns (ArektaPoysha) {
        vm.startBroadcast();
        ArektaPoysha arektaPoysha = new ArektaPoysha(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return arektaPoysha;
    }
}
