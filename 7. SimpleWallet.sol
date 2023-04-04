// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {

    //Safe Math
    using SafeMath for uint;

    // Register event that fires when we change allowance
    event AllowanceChanged(address indexed _to, address indexed _sender, uint _oldAmount, uint _newAmount);

    // Map address to deposit allowance
    mapping(address => uint) public allowance;

    //Only owner or those who have deposited amounts can withdraw.
    modifier ownerOrAllowed(uint _amount){
        require(allowance[msg.sender] >= _amount,  "You are not allowed");
        _;
    }

    //Map allowance to address
    function addAllowance(address _who, uint _amount) public {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    //Reduce allowance for non contract owners
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
}

contract SimpleWallet is Allowance {
    //Register event that fires when we send money.
    event  MoneySent(address indexed _to, uint _amount);

    //Register event that fires when we receive money.
    event  MoneyReceive(address indexed _from, uint _amount);
    
    //Owner can withraw unlimited. notOwner what they have deposited
    function withdrawMoney(address payable _to, uint _amount) public onlyOwner ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough funds stored in wallet");
        if(!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to);
        _to.transfer(_amount);
    }

    function renounceOwnership() public {
        revert("Can't renounce ownership here");
    }

    // Wallet fallback function when unexistant function is called.
     fallback() external payable {
         
    }
    // Receive Ether
    receive() external payable{
        emit MoneyReceive(msg.sender, msg.value);
    }
}