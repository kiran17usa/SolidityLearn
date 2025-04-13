//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract FallbackExample{
    uint256 public result;
    //no function keyword - its a special function
    //will be triggered with any interactions with the cotract ex: calldata during deploy - with empty
    receive() external payable {
        result =1;
    }
    //if you specify some thing while call data and not declared respective function it expects a fallback funciton to redirect to automatically
    fallback() external payable{
        result = 2;
    }
    //call data with 0x00 or something triggers fallback and result =2
}
