// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SurveyFactory.sol";

contract DeploySurveyFactory is Script {
    function run() external {
        vm.startBroadcast();
        new SurveyFactory();
        vm.stopBroadcast();
    }
}
