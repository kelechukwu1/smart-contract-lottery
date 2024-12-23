//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCordinator = helperConfig.getConfig().vrfCoordinator;
        //create a subscription
        (uint256 subId, ) = createSubscription(vrfCordinator);
        return (subId, vrfCordinator);
    }

    function createSubscription(
        address vrfCordinator
    ) public returns (uint256, address) {
        console.log("Creating subscription on chain Id:", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCordinator)
            .createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription Id is:", subId);
        console.log(
            "Please update the Subscription Id in your Helperconfig.s.sol"
        );
        return (subId, vrfCordinator);
    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script {
    uint256 public constant FUND_AMOUNT = 3 ether; //3 LINK

    function subSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        fundSubscription(vrfCordinator, subscriptionId, linkToken);
    }

    function fundSubscription(
        address vrfCoordinator,
        uint256 subscriptionId,
        address linkToken
    ) public {
        console.log("Funding subscription: ", subscriptionId);
        console.log("Using VrfCoordinator: ", vrfCoordinator);
        console.log("Onchain Id: ", block.chainid);
    }

    function run() public {
        subSubscriptionUsingConfig();
    }
}
