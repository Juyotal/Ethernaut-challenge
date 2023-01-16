// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";


contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        vm.startBroadcast();
        bytes32 _password = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29;
        //could unfortunately not access the password through Solidity. had to use web3 js library with the script "web3.eth.getStorageAt"
        //in Solidity, storage state variables can also be accessed by using assembly command *sload* but this only exists within the scope
        // of the contract code and cant be used to access storage state varaibles of a different contract.

        Vault(0x25f1450efa63CBA63bEb18901604901cff945635).unlock(_password);
        vm.stopBroadcast();

    }

}