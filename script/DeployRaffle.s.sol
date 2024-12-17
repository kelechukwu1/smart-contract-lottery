//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        // HelperConfig helperConfig = new HelperConfig();
        // address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        // vm.startBroadcast();
        // Raffle raffle = new Raffle();
        // vm.stopBroadcast();
        // return fundMe;
    }
}
