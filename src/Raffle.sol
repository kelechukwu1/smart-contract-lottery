// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

/**
 * @title A sample Raffle contract
 * @author Kelechukwu Ikechukwu
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */

contract Raffle {
    // Errors
    error Raffle__SendMoreToEnterRaffle();

    // State variables
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRafle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!"); This is not gas efficient because it is storing strings
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle()); This won't work with the solidity version of this contract

        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));
    }

    function pickWinner() public {}

    /**Getter functions */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
