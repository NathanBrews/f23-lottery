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
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
/**
 * @title Sample Raffle Contract
 * @author Nathaniel Brewster
 * @notice This contract is for creating a sample raffle contract
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle {
    // error
    error NotEnoughEthSent();
    //
    uint256 private immutable s_enteranceFee;
    // @dev Duration of the lottery in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /**Events */
    event EnteredRaffle(address indexed player);
    // constructor
    constructor(uint256 entranceFee, uint256 interval) {
        i_enteranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }
    function enterRaffle()  external payable () {
        // require(msg.sender >= i_enteranceFee, "Not enough ETH sent!");
        if (msg.value < i_enteranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        //
        emit EnteredRaffle(msg.sender);
    }
    function pickWinner() public () {
       if (block.timpStamp - s_lastTimeStamp < i_interval);
       revert();
    }
    /** Getter Function */
    function getEnteranceFee() external view returns(uint256){
        return i_enteranceFee;
    }
}