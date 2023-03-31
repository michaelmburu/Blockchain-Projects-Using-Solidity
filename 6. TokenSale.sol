// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

//Mint tokens using the CoffeeToken contract and whitelist the tokenSale contract in the increaseAllowance method.
// Then proceed to purchase transactions using the token sale contract

abstract contract ERC20 {
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool sucess);
    function decimals() public virtual view returns (uint8);
}

contract TokenSale {
    uint public tokenPriceInWei = 1 ether;

    ERC20 public token;
    address tokenOwner;

    constructor(address _token){
        tokenOwner = msg.sender;
        token = ERC20(_token);
    }

    function purchaseCoffee() public payable{
        require(msg.value >= tokenPriceInWei, "Not enough money sent");
        uint tokensToTransfer = msg.value / tokenPriceInWei;
        uint remainder = msg.value - tokensToTransfer * tokenPriceInWei;
        token.transferFrom(tokenOwner, msg.sender, tokensToTransfer * 10 ** token.decimals());
        payable(msg.sender).transfer(remainder); //Send the rest of the money back.
    }

}