//fund from users
//withdraw by owner
//fund in terms of USD
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
//import {AggregatorV3Interface} from "./AggregatorV3Interface.sol"; if we have the below contract in another file in this folder
//import {PriceConverter} from "./PriceConverter1.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice() internal view returns(uint256){
        //chainlink pricefeed eth/usd on sepolia test net address
        //0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);//sepolia testnet eth-usd address
        (, int256 price, , , )= priceFeed.latestRoundData();
        //price of ETH in terms of USD
        return uint256(price*1e10);
    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice *ethAmount)/1e18;
        return ethAmountInUsd;
    }
    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);//sepolia testnet eth-usd address
        return priceFeed.version();
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
//import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//get the below from chainlink github page for the interface
//https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol

// solhint-disable-next-line interface-starts-with-i
/*
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}
*/

error NotOwner();
//1005449  - gas for creation

contract FundMe{
    using PriceConverter for uint256;
    //uint256 public myValue =1;
    uint256 public constant MINIMUM_USD = 5*1e18; //constant will reduce a lil bit gas on contract
    //less gas cost diff for above constant or non constant
    //what if more funders
    address[] public funders;
    mapping(address=>uint256)public addressToAmountFunded;
    address public immutable i_owner;
    //mutable and immutable owner gas cost changes
    constructor(){
        //address to pay the fund
        i_owner = msg.sender; //only owner can withdraw and setting owner as contract owner
    }

    function fund() public payable {
        //allow users to send
        //have min $ sent
        //how do we send eth to this contract
        //1 *10* 18 times - a min >1 eth shall fund if not it will revert the transaction
        //myValue = myValue +2;
        //require(msg.value>1, "didnt send enough eth");
        //afte using library of priceconverter the below require is not required
        //msg.value.getConversionRate(); // needs eth which will come from msg.value
        //the above can write as below
        require(msg.value.getConversionRate()>MINIMUM_USD, "Didnt send enough eth");
        //msg.value above is uint256 and can call all priceConverter1 function due to using method
        //require(getConversionRate(msg.value)> minimumUsd, "Didnt send enough eth");  
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
/*    
    function getPrice() public view returns(uint256){
        //chainlink pricefeed eth/usd on sepolia test net address
        //0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , )= priceFeed.latestRoundData();
        //price of ETH in terms of USD
        return uint256(price*1e10);
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice *ethAmount)/1e18;
        return ethAmountInUsd;
    }
    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
    */
    function withdraw()public onlyOwner{
        //require(msg.sender ==owner, "must be owner")
        //for loop
        //[1,2,3,4]
        for(uint256 funderIndex =0;funderIndex<funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }
        //reset the array
        funders = new address[](0);
        //withdraw funds
        //transfer, send, call
        //msg.sender = address
        //payable(msg.sender) = payable address
        //3 ways
        //transfer
        payable(msg.sender).transfer(address(this).balance);
        //send
        bool sendSuccess =payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "send failed");
        //call
        (bool callSuccess, )=payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }
    //modifier
    modifier onlyOwner(){
        //require(msg.sender == i_owner, "sender is not the owner");
        if(msg.sender != i_owner){revert NotOwner();}
        _; // order of the underscore matters
        //if it first - then execute function first then require
        //if it last  - require first then execution of the function later
    }
    //special functions - receive and fallback
    //somebody accidentally transacts - we are handling with fund()
    receive() external payable {
        fund();
    }
    fallback() external payable{
        fund();
    }
}