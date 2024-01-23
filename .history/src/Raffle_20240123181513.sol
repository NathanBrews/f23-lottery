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
    error NotEnoughEthSent();
    uint256 private s_enteranceFee;
    
    constructor(uint256 entranceFee) {
        i_enteranceFee = entranceFee;
    }
    function enterRaffle()  external payable () {
        // require(msg.sender >= i_enteranceFee, "Not enough ETH sent!");
        if (msg.value < i_enteranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
    }
    function pickWinner() public () {}
    /** Getter Function */
    function getEnteranceFee() external view returns(uint256){
        return i_enteranceFee;
    }
}