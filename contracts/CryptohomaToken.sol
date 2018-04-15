pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";

/**
 * Контракт CryptoHoma наследуется от контракта MintableToken из фреймворка OpenZeppeline
 */
contract CryptohomaToken is StandardToken, MintableToken, BurnableToken {
    
    string public name = "CryptoHoma";
    string public symbol = "HOMA";
    uint public decimals = 18;

}