// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
/**
 * @title Sample Raffle Contract
 * @author Nathaniel Brewster
 * @notice This contract is for creating a sample raffle contract
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle {
    uint256 private s_enteranceFee;
    
    constructor(uint256 entranceFee) {
        i_enteranceFee = entranceFee;
    }
    function enterRaffle()  public payable () {
        
    }
    function pickWinner() public () {}
}