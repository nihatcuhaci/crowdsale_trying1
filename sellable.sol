// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
contract Sellable {
    IERC20 public token;
    uint price;
    uint256 maxAmountPerAddress;
    uint256 public constant one = 10**18;
    mapping (address => uint) addressTokenCount;
    uint256 tokensUnlockTime;
    bool Paused = false;
    address owner;

    event Bought(uint256 amount);

    constructor(address _token,uint _price, uint256 _maxAmountPerAddress, uint256 _tokensUnlockTime) {
        token = IERC20(_token);
        price = _price;
        maxAmountPerAddress = _maxAmountPerAddress;
        tokensUnlockTime = _tokensUnlockTime;
        owner = msg.sender;
    }

    function buy(uint amount) external payable {
       require(Paused == false);
        require(tokensUnlockTime < block.timestamp, " unlocked!");
        require(addressTokenCount[msg.sender] < maxAmountPerAddress, "there is no enough token");
        require(msg.value > amount*price*one,"not enough eth");
        token.transfer(msg.sender,amount);
        addressTokenCount[msg.sender] += amount;
        emit Bought(amount);
    }

   function pauseSale() public {
        require(msg.sender == owner);
        Paused = true;
    }

    function continueSale() public {
        require(msg.sender == owner);
        Paused = false;
    }

    function viewPrice() public view returns(uint) {
        return price;
    }

    function viewUnlockTime() public view returns(uint256) {
        return tokensUnlockTime;
    }
}
