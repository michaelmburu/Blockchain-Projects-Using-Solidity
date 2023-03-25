// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract SampleFallback {
    uint public lastValueSent;
    string public lastFunctionCalled;
    uint public myUint;

    function setMyUint(uint _myNewUint) public {
        myUint = _myNewUint;
    }
    
    //If you have both functions, when you send ether with call data it will call fallback

     // If you you only have receive function you can only send ether and it will call receive
        lastValueSent = msg.value;
        lastFunctionCalled = "receive";
    }

    // If you you only have fallback function you can send both ether and call data (if it's marked as payable)
    fallback() external payable {
        lastValueSent = msg.value;
        lastFunctionCalled = "fallback";
    }


}