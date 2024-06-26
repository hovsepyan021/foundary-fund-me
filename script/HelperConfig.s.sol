// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 18;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if(block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory)  {
        NetworkConfig memory networkConfig = NetworkConfig(
            {
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            }
        );
        return networkConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory networkConfig = NetworkConfig(
            {
                priceFeed: address(mock)
            }
        );
        return networkConfig;
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory networkConfig = NetworkConfig(
            {
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            }
        );
        return networkConfig;
    }
}