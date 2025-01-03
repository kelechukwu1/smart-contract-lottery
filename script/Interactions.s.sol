//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig, CodeConstants} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCordinator = helperConfig.getConfig().vrfCoordinator;
        address account = helperConfig.getConfig().account;
        //create a subscription
        (uint256 subId, ) = createSubscription(vrfCordinator, account);
        return (subId, vrfCordinator);
    }

    function createSubscription(
        address vrfCordinator,
        address account
    ) public returns (uint256, address) {
        console.log("Creating subscription on chain Id:", block.chainid);
        vm.startBroadcast(account);
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

contract AddConsumer is Script {
    function addConsumerUsingConfig(address mostRecentlyDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        address account = helperConfig.getConfig().account;
        uint256 subId = helperConfig.getConfig().subscriptionId;
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        addConsumer(mostRecentlyDeployed, vrfCoordinator, subId, account);
    }

    function addConsumer(
        address contractToAddToVrf,
        address vrfCoordinator,
        uint256 subId,
        address account
    ) public {
        console.log("Adding Consumer contract:", contractToAddToVrf);
        console.log("Adding To VRF Coordinator:", vrfCoordinator);
        console.log("On chainId:", block.chainid);
        vm.startBroadcast(account);
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(
            subId,
            contractToAddToVrf
        );
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(mostRecentlyDeployed);
    }
}

contract FundSubscription is Script, CodeConstants {
    uint256 public constant FUND_AMOUNT = 3 ether; //3 LINK

    function subSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;

        address account = helperConfig.getConfig().account;

        // if (subId == 0) {
        //     CreateSubscription createSub = new CreateSubscription();
        //     (uint256 updatedSubId, address updatedVRFv2) = createSub.run();
        //     subId = updatedSubId;
        //     vrfCoordinatorV2_5 = updatedVRFv2;
        //     console.log("New SubId Created! ", subId, "VRF Address: ", vrfCoordinatorV2_5);
        // }
        fundSubscription(vrfCordinator, subscriptionId, linkToken, account);
    }

    function fundSubscription(
        address vrfCoordinator,
        uint256 subscriptionId,
        address linkToken,
        address account
    ) public {
        console.log("Funding subscription: ", subscriptionId);
        console.log("Using VrfCoordinator: ", vrfCoordinator);
        console.log("Onchain Id: ", block.chainid);
        if (block.chainid == LOCAL_CHAIN_ID) {
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subscriptionId,
                FUND_AMOUNT * 100
            );
            console.log("funded with:", FUND_AMOUNT * 100);
            vm.stopBroadcast();
        } else {
            console.log(LinkToken(linkToken).balanceOf(msg.sender));
            console.log(msg.sender);
            console.log(LinkToken(linkToken).balanceOf(address(this)));
            console.log(address(this));
            vm.startBroadcast(account);
            LinkToken(linkToken).transferAndCall(
                vrfCoordinator,
                FUND_AMOUNT,
                abi.encode(subscriptionId)
            );
            vm.startBroadcast();
        }
    }

    function run() public {
        subSubscriptionUsingConfig();
    }
}
