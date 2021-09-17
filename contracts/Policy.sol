pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "./bUKH.sol";
import "./sUKH.sol";

contract Policy is OwnableUpgradeable {
    using SafeMathUpgradeable for uint256;

    uint256 constant RATE_DECIMAL = 4;

    uint256 public ratebUKHTosUKH;
    uint256 public ratesUKHTobUKH;

    bUKH tokenbUKH;
    sUKH tokensUKH;

    function initialize(address _bUKH, address _sUKH) public initializer {
        __Ownable_init();

        ratesUKHTobUKH = 10**RATE_DECIMAL;
        ratebUKHTosUKH = 5 * 10**3;

        tokenbUKH = bUKH(_bUKH);
        tokensUKH = sUKH(_sUKH);
    }

    function setRatebUKHTosUKH(uint256 _rate) external onlyOwner {
        require(_rate > 0);
        ratebUKHTosUKH = _rate;
    }

    function setRatesUKHTobUKH(uint256 _rate) external onlyOwner {
        require(_rate > 0);
        ratesUKHTobUKH = _rate;
    }

    function changebUKHAddress(address _bUKH) external onlyOwner {
        require(_bUKH != address(0x0));
        tokenbUKH = bUKH(_bUKH);
    }

    function changesUKHAddress(address _sUKH) external onlyOwner {
        require(_sUKH != address(0x0));
        tokensUKH = sUKH(_sUKH);
    }

    function burnsUKH(uint256 amount) external {
        tokensUKH.burn(msg.sender, amount);

        uint256 change = amount.mul(ratesUKHTobUKH).div(10**RATE_DECIMAL);
        tokenbUKH.mint(msg.sender, change);
    }

    function burnbUKH(uint256 amount) external {
        tokenbUKH.burn(msg.sender, amount);

        uint256 change = amount.mul(ratebUKHTosUKH).div(10**RATE_DECIMAL);
        tokensUKH.mint(msg.sender, change);
    }
}
