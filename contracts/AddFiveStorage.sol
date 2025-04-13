//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {SimpleStorage1} from "./SimpleStorage1.sol";

contract AddFiveStorage is SimpleStorage1{
      //+5
      //overrides
      //virtual overrides
      function store(uint256 _newNumber) public override{
            myFavouriteNumber = _newNumber+5;
      }
}