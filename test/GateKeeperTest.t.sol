// pragma solidity ^0.8;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// import "script/GateKeeperAttack.sol";

// contract TestGateKeeperOne is Test {
//     address private target;
//     // GatekeeperOne private target;
//     Hacker private hack;

//     function setUp() public {
//         target = 0xdb2A3d6c6E49471134ffEABA68CBd5c2D0fE17A0;
//         hack = new Hacker();
//     }

//     function test() public {
//         for (uint256 i = 100; i < 8191; i++) {
//             try hack.enter(address(target), i) {
//                 console.log("gas", i);
//                 return;
//             } catch {}
//         }
//         revert("all failed");
//     }
// }