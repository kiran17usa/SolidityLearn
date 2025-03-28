//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";
contract StorageFactory{
    SimpleStorage[] public simpleStorageArray;
    function createSimpleStorageContract() public{
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //Address
        //ABI - application binary interface
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
        //instead of above two lines
        //simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve();
        //instead of above two lines
        //return simpleStorageArray[_simpleStorageIndex].retreive();
    }
}