// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/CoinFlip/CoinFlipAttack.sol";


contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        CoinFlipAttack coinFlip = new CoinFlipAttack(0x60879fA2c968864e5F2CCe68705837e18Fb96d80);

        coinFlip.flip();

        vm.stopBroadcast();
    }
}