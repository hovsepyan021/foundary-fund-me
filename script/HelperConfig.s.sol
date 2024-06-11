// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract HelperConfig {
    NetworkConfig public activeNetworkConfig;

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
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

    function getAnvilEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory networkConfig = NetworkConfig(
            {
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            }
        );
        return networkConfig;
    }
}