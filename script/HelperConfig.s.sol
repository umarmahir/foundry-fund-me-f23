// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    MockV3Aggregator mockPriceFeed;

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getEthereumConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getEthereumConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethereumConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethereumConfig;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory){

        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;

    }
}
