//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Raffle} from "../src/Raffle.sol";

abstract contract RaffleTest is Raffle {
    function testGetEntranceFee() internal view returns (uint256) {
        // assertEq();
    }
}
