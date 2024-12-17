//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

// import {Raffle} from "src/Raffle.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {}

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig(
                0.01 ether,
                30,
                0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
                0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
                0,
                500000
            );
    }
}
