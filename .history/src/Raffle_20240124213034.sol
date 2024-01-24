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
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
// import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title Sample Raffle Contract
 * @author Nathaniel Brewster
 * @notice This contract is for creating a sample raffle contract
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle is VRFConsumerBaseV2 {
    // error
    error Raffle__NotEnoughEthSent();
    error Raffle__TransferFailed();
    // Type declaration
    enum RaffleState {
        OPEN,
        CALCULATING
    }
    // State variable
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    //
    // @dev Duration of the lottery in seconds
    uint256 private immutable i_interval;
    uint256 private immutable i_enteranceFee;
    uint256 private s_lastTimeStamp;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    //
    address private s_recentWinner;
    address payable[] private s_players;
    RaffleState private s_raffleState;

    /**Events */
    event EnteredRaffle(address indexed player);
    // constructor keyhash is gaslane
    constructor(
        uint256 entranceFee, 
        uint256 interval,
        address vrfCoordinator, 
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
        ) VRFConsumerBaseV2(vrfCoordinator){
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_interval = interval;
        i_subscriptionId = subscriptionId;
        i_enteranceFee = entranceFee;
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        i_callbackGasLimit = callbackGasLimit;
    }
    function enterRaffle()  external payable {
        // require(msg.sender >= i_enteranceFee, "Not enough ETH sent!");
        if (msg.value < i_enteranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        //
        emit EnteredRaffle(msg.sender);
    }
    function pickWinner() external {
       if ((block.timestamp - s_lastTimeStamp) < i_interval) {
        revert();
        }
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }
    
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        // s_players size 10
        // randomNumber 202
        // 202 % 10 ? what's doesn't divide evenly into 202?
        // 20 * 10 = 200
        // 2
        // 202 % 10 = 2
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        // s_players = new address payable[](0);
        // s_raffleState = RaffleState.OPEN;
        // s_lastTimeStamp = block.timestamp;
        // emit WinnerPicked(recentWinner);
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // require(success, "Transfer failed");
        if (!success) {
            revert Raffle__TransferFailed();
        }

        }
    /** Getter Function */
    function getEnteranceFee() external view returns(uint256){
        return i_enteranceFee;
    }
}