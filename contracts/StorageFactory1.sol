//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./SimpleStorage1.sol";
//how to import seperate contracts from a file
//ex : import {SimpleStorage1, SimpleStorage2} from "./SimpleStorage.sol"
contract StorageFactory1{
    //uint256 public favouriteNumber;

    SimpleStorage1 public simpleStorage1;
    function createSimpleStorageContract()public {
        simpleStorage1 = new SimpleStorage1();
    }

}
contract StorageFactory2{ //intended for lists
    SimpleStorage1[] public listOfSimpleStorage1Contracts;
    //address[] public listOfSimpleStorage1Addresses;
    function createSimpleStorageContract() public {
        SimpleStorage1 newSimpleStorageContract = new SimpleStorage1();
        listOfSimpleStorage1Contracts.push(newSimpleStorageContract);
    }
    //
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber)public{
        //Address
        //ABI - application binery interface
        SimpleStorage1 mySimpleStorage = listOfSimpleStorage1Contracts[_simpleStorageIndex];
        //SimpleStorage1 mysimpleStorage = listOfSimpleStorage1Addresses[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);

    }
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        SimpleStorage1 mySimpleStorage = listOfSimpleStorage1Contracts[_simpleStorageIndex];
        return mySimpleStorage.retreive();
        //return listOfSimpleStorage1Contracts[_simpleStorageIndex].retreive();
    }
}