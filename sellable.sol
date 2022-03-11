// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
contract Sellable {
    uint price =1;
    IERC20 public token;
    address payable skimmer;
    constructor(address _token, uint _price) public {
        token= IERC20(_token);
        price= _price;
        skimmer= payable(msg.sender);
    }

    function buy(uint amount) external payable {
        require (msg.value > amount*price, "not enough ETH");
        token.transfer(msg.sender, amount);
    }

    function skim () external {
        skimmer.transfer(payable(address(this)).balance);

    }

}