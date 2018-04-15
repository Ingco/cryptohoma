pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./CryptohomaToken.sol";

contract CryptohomaCrowdsale is MintedCrowdsale, Ownable, BasicToken {
    
    // Начало Crowdsale - 15.04.2018 09:00:00
    uint start = 1523782800; //1523145601;

    // Период сбора денег
    uint period = 31;

    // Адрес получателя средств, переданных за токены
    address public multisig = 0x16dc1a72b44997a5e169874f901570bc687a2ee0;

    // Всего будет выпущено    
    uint256 public totalSupply = 50000000 * 1 ether;

    // Всего токенов выпустили
    uint256 public totalMinted;
    
    CryptohomaToken public token = new CryptohomaToken();

    // Процент на Pre-Sale 
    uint public presale_percent = 5;
    // Процент на Рекламу
    uint public bounty_percent = 5;
    // Процент на AirDrop
    uint public airdrop_percent = 2;
    // Процент организаторов
    uint public organizers_percent = 15;

    address public presale = 0x1e363e5af2ba28c40abf56d6d0f6fd91445d6bab;
    address public bounty = 0x5fec0d2733b28e89d4df7a052b95160e324e2274;
    address public airdrop = 0xcbe9df774b77ecb64c6e695bb9731d9a42a6de7a;
    // Кошельки организаторов
    address public organizer1 = 0x77f5f6b39e00f0fbaa4d943d65983d17ed7e0fa4;
    address public organizer2 = 0x90e0a14d75ecd5f301be8f9e2081fab12bb8adb2;
    address public organizer3 = 0x7cc3e141b41ee40904dd293c150281925daed9d6;
    address public organizer4 = 0x56c2c7a7391e17399aa7a03e03463fa1f5eb693a;
    address public organizer5 = 0x571bc2033f7b495f6630bc3c429649c0af417469;
    address public organizer6 = 0xe7da66b24212a08e6bbb1abe93b8d1ff35e37c41;
    address public organizer7 = 0x26b038b6199f81df008e2664a36a3e842b0895d6;
    address public organizer8 = 0x76a4da392034418cee3e79c28f47f982b1522677;
    // Стоимость токена в wei
    uint256 public rate = 0.000011 * 1 ether;
    uint256 public rate2 = 0.000015 * 1 ether;
    
    function CryptohomaCrowdsale (
        //address _wallet
    ) public Crowdsale(rate, multisig, ERC20(token)) {
 
        // Отправляем токены на pre-sale
        uint256 tokens = totalSupply.mul(presale_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // Выпускаем токены на адрес
        token.mint(presale, tokens);

        // Отправляем токены на bounty
        tokens = totalSupply.mul(bounty_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // Выпускаем токены на адрес
        token.mint(bounty, tokens);

        // Отправляем на Air Drop
        tokens = totalSupply.mul(airdrop_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // Выпускаем токены на адрес
        token.mint(airdrop, tokens);

        // Токены для организаторов
        tokens = totalSupply.mul(organizers_percent).div(100);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);
        // берем 8-ую часть и переправлем организаторам
        tokens = tokens.div(8);
        // Выпускаем токены на адреса
        token.mint(organizer1, tokens);
        token.mint(organizer2, tokens);
        token.mint(organizer3, tokens);
        token.mint(organizer4, tokens);
        token.mint(organizer5, tokens);
        token.mint(organizer6, tokens);
        token.mint(organizer7, tokens);
        token.mint(organizer8, tokens);

    }

    /**
     * @dev Заканчиваем распродажу. Выполняет только владелец токена
     */
    function finishCrowdsale() onlyOwner public {
        // Переводим собранный Эфир на счет организатора
        multisig.transfer(this.balance);

        token.finishMinting();
    }

    /**
    * @dev Determines how ETH is stored/forwarded on purchases. ***ПЕРЕОПРЕДЕЛЕНО***
    */
    function _forwardFunds() internal {
        //wallet.transfer(msg.value);
    }

    /**
    * @dev Override to extend the way in which ether is converted to tokens. ***ПЕРЕОПРЕДЕЛЕНО***
    * @param _weiAmount Value in wei to be converted into tokens
    * @return Number of tokens that can be purchased with the specified _weiAmount
    */
    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        // Если с начала распродаж прошло 14 дней, то повышаем цену на токен
        if (now > start.add(15 * 1 days)) {
            rate = rate2;
        }
        
        return _weiAmount.div(rate);
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

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(_weiAmount);
        // Считаем выпущенные токены
        totalMinted = totalMinted.add(tokens);

        // Выпущенных токенов должно быть меньше общего кол-ва
        require(totalSupply >= totalMinted);

    }
}