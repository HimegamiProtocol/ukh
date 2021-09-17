pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract sUKH is ERC20Upgradeable, OwnableUpgradeable {
    using SafeMathUpgradeable for uint256;

    uint256 constant INITIAL_SUPPLY = 470_000_000 * 10**18;

    mapping(address => bool) minters;

    bool public paused;

    modifier onlyMinter() {
        require(minters[msg.sender] == true, "Only minter");
        _;
    }

    modifier whenNotPaused() {
        require(
            paused == false || minters[msg.sender] == true,
            "Transfer was locked"
        );
        _;
    }

    function initialize() public initializer {
        __Ownable_init();

        __ERC20_init("sUKHI", "sUKH");

        _mint(owner(), INITIAL_SUPPLY);

        minters[owner()] = true;

        paused = true;
    }

    function addMinter(address _minter) external onlyOwner {
        require(_minter != address(0x0));
        minters[_minter] = true;
    }

    function removeMinter(address _minter) external onlyOwner {
        require(_minter != address(0x0));
        minters[_minter] = false;
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
    }

    function isPaused() external view returns (bool) {
        return paused;
    }

    function mint(address _to, uint256 _amount) external onlyMinter {
        _mint(_to, _amount);
    }

    function burn(address _account, uint256 _amount) external onlyMinter {
        _burn(_account, _amount);
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        whenNotPaused
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override whenNotPaused returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            allowance(sender, msg.sender).sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }
}
