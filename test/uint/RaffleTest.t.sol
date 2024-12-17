//SPDX-License-Identifier:MIT

// abstract contract RaffleTest is Test {
//     Raffle public raffle;
//     HelperConfig public helperConfig;

//     uint256 entranceFee;
//     uint256 interval;
//     address vrfCoordinator;
//     bytes32 gasLane;
//     uint256 subscriptionId;
//     uint32 callbackGasLimit;

//     address public PLAYER = makeAddr("player");
//     uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

//     function setUp() external {
//         DeployRaffle deployer = new DeployRaffle();
//         (raffle, helperConfig) = deployer.deployContract();

//         HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

//         entranceFee = config.entranceFee;
//         interval = config.interval;
//         gasLane = config.gasLane;
//         vrfCoordinator = config.vrfCoordinator;
//         callbackGasLimit = config.callbackGasLimit;
//         subscriptionId = config.subscriptionId;
//     }

//     function testInitializesInOpenState() public view {
//         assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
//     }

//     function testRaffleRevertsWhenYouDOntPayEnough() public {
//         //Arrange
//         vm.prank(PLAYER);
//         //Act/Asset
//         vm.expectRevert(Raffle.Raffle__SendMoreToEnterRaffle.selector);
//         raffle.enterRaffle();
//     }

//     function testGetEntranceFee() public view {
//         uint256 expectedEntranceFee = entranceFee;
//         assert(raffle.getEntranceFee() == expectedEntranceFee);
//     }

pragma solidity ^0.8.19;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Test, console2} from "forge-std/Test.sol";

// import {Vm} from "forge-std/Vm.sol";
// import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
// import {LinkToken} from "../../test/mocks/LinkToken.sol";
// import {CodeConstants} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    event RequestedRaffleWinner(uint256 indexed requestId);
    event RaffleEnter(address indexed player);
    event WinnerPicked(address indexed player);

    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 subscriptionId;
    bytes32 gasLane;
    uint256 automationUpdateInterval;
    uint256 raffleEntranceFee;
    uint32 callbackGasLimit;
    address vrfCoordinatorV2_5;
    // LinkToken link;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant LINK_BALANCE = 100 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        raffleEntranceFee = config.entranceFee;
        automationUpdateInterval = config.interval;
        gasLane = config.gasLane;
        vrfCoordinatorV2_5 = config.vrfCoordinator;
        callbackGasLimit = config.callbackGasLimit;
        subscriptionId = config.subscriptionId;
        vm.deal(PLAYER, STARTING_USER_BALANCE);
    }

    function testRaffleInitializesInOpenState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    /*//////////////////////////////////////////////////////////////
                              ENTER RAFFLE
    //////////////////////////////////////////////////////////////*/
    function testRaffleRevertsWHenYouDontPayEnough() public {
        // Arrange
        vm.prank(PLAYER);
        // Act / Assert
        vm.expectRevert(Raffle.Raffle__SendMoreToEnterRaffle.selector);
        raffle.enterRaffle();
    }

    function testRaffleRecordsPlayersWhenTheyEnter() public {
        //Arrange
        vm.prank(PLAYER);
        //Act
        raffle.enterRaffle{value: raffleEntranceFee}();
        //Asset
        address playerRecorded = raffle.getPlayer(0);
        assert(playerRecorded == PLAYER);
    }
    // function testGetEntranceFee() public view {
    //     uint256 expectedEntranceFee = raffleEntranceFee;
    //     assert(raffle.getEntranceFee() == expectedEntranceFee);
    // }
}
