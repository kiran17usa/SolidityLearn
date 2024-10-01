//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {
    uint256  favouriteNumber;
    //People public person = People({favouriteNumber: 2, name:"Kiran" });
    struct People {
         uint256 favouriteNumber;
         string name;
    }

    //array
    //uint256[] public favouriteNumbersList;
    People[] public people;
    function store(uint256 _favouriteNumber) public virtual {
        favouriteNumber = _favouriteNumber;
        //uint256 testVar = 5;
    
    }

    function retrieve() public view returns(uint256){
        return favouriteNumber;
    }
    //calldata, memory, storage
    mapping(string => uint256) public nameToFavouriteNumber;
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        //people.push(People(_favouriteNumber, _name));
        //People memory newPerson = People({favouriteNumber:_favouriteNumber, name: _name});
        //People memory newPerson = People(_favouriteNumber, _name);
        //people.push(newPerson);
        people.push(People(_favouriteNumber, _name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
    function add() public pure returns (uint256){
        return(1 + 1);
    }
}