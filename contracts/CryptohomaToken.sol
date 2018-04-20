pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";

/**
 * Контракт CryptoHoma
 */
contract CryptohomaToken is StandardToken, MintableToken, BurnableToken {
    
    string public name = "CryptoHoma3";
    string public symbol = "HOMA3";
    uint public decimals = 18;

}