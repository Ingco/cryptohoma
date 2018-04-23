pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";

/**
 * Контракт TestToken
 */
contract CryptohomaToken is StandardToken, MintableToken, BurnableToken {
    
    string public name = "CryptohomaToken";
    string public symbol = "HOMA";
    uint public decimals = 18;

    using SafeMath for uint256;

    // Amount of wei raised
    uint256 public weiRaised;

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    buyTokens(msg.sender);
  }

  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    _processPurchase(_beneficiary, tokens);
    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);

    _forwardFunds();
  }

    // Начало Crowdsale
    uint start = 1523782800;

    // Период сбора денег
    uint period = 31;

    // Адрес получателя средств, переданных за токены
    address public multisig = 0x16Dc1a72B44997A5e169874f901570Bc687a2ee0;

    // Всего будет выпущено
    uint256 public totalSupply = 50000000 * 1 ether;

    // Всего токенов выпустили
    uint256 public totalMinted;

    // Процент на Pre-Sale = 3.125
    uint256 public presale_tokens = 1562500 * 1 ether;
    // Процент на Рекламу
    uint public bounty_percent = 5;
    // Процент на AirDrop
    uint public airdrop_percent = 2;
    // Процент организаторов
    uint public organizers_percent = 15;

    address public presale = 0x1e363e5AF2bA28C40abf56d6D0f6Fd91445d6bAB;
    address public bounty = 0x5FEc0d2733b28e89d4DF7A052B95160E324e2274;
    address public airdrop = 0xcbe9df774b77eCb64C6E695BB9731d9a42a6dE7a;
    // Кошельки организаторов
    address public organizer1 = 0x77F5F6b39e00f0fBaa4D943d65983D17ed7e0fa4;
    address public organizer2 = 0x90e0A14d75ECD5f301be8F9e2081faB12BB8ADB2;
    address public organizer3 = 0x7Cc3E141B41ee40904dD293C150281925daED9d6;
    address public organizer4 = 0x56c2c7A7391e17399aa7A03e03463fa1f5EB693a;
    address public organizer5 = 0x571bC2033F7b495F6630bc3c429649c0af417469;
    address public organizer6 = 0xE7DA66b24212a08e6bBb1abe93b8D1Ff35E37C41;
    address public organizer7 = 0x26B038B6199f81dF008e2664a36a3e842b0895d6;
    address public organizer8 = 0x76A4dA392034418CEe3e79c28f47F982b1522677;
    // Стоимость токена в wei
    uint256 public rate = 0.000011 * 1 ether;
    uint256 public rate2 = 0.000015 * 1 ether;

    function TestTokenH6() public {

        // Считаем выпущенные токены
        totalMinted = totalMinted.add(presale_tokens);
        // Выпускаем токены на адрес
        super.mint(presale, presale_tokens);

        // Отправляем токены на bounty
        uint256 tokens = totalSupply.mul(bounty_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // Выпускаем токены на адрес
        super.mint(bounty, tokens);

        // Отправляем на Air Drop
        tokens = totalSupply.mul(airdrop_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // Выпускаем токены на адрес
        super.mint(airdrop, tokens);

        // Токены для организаторов
        tokens = totalSupply.mul(organizers_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // берем 8-ую часть и переправлем организаторам
        tokens = tokens.div(8);
        // Выпускаем токены на адреса
        super.mint(organizer1, tokens);
        super.mint(organizer2, tokens);
        super.mint(organizer3, tokens);
        super.mint(organizer4, tokens);
        super.mint(organizer5, tokens);
        super.mint(organizer6, tokens);
        super.mint(organizer7, tokens);
        super.mint(organizer8, tokens);

    }

    /**
    * @dev Override to extend the way in which ether is converted to tokens. ***ПЕРЕОПРЕДЕЛЕНО***
    * @param _weiAmount Value in wei to be converted into tokens
    * @return Number of tokens that can be purchased with the specified _weiAmount
    */
    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount / rate * 1 ether;
    }

  /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations. ***ПЕРЕОПРЕДЕЛЕНО***
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
        require(_beneficiary != address(0));
        require(_weiAmount != 0);

        require(now > start && now < start + period * 1 days);

        // Если с начала распродаж прошло 14 дней, то повышаем цену на токен
        if (now > start.add(15 * 1 days)) {
            rate = rate2;
        }

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(_weiAmount);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);

        // Выпущенных токенов должно быть меньше общего кол-ва
        require(totalSupply >= totalMinted);

    }

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    super.transfer(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    multisig.transfer(msg.value);
  }

}