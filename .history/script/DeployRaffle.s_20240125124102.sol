// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {Raffle} from "../src/Raffle.sol";
//
//
contract DeployRaffle is Script {
    function run() external view returns (Raffle) {
        HelperConfig helperConfig = new HelperConfig();
        ( uint256 entranceFee,
        uint256 interval,
        // address link,
        address vrfCoordinatorV2,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        // uint256 deployerKey,
        ) = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinatorV2,
            gasLane,
            subscriptionId,
            callbackGasLimit
        );
        vm.stopBroadcast();
        return raffle;
    }
}