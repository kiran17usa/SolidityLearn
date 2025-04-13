//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
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