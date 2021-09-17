pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract bUKH is ERC20Upgradeable, OwnableUpgradeable {
    uint256 constant INITIAL_SUPPLY = 30_000_000 * 10**18;

    mapping(address => bool) minters;

    bool public paused;

    modifier onlyMinter() {
        require(minters[msg.sender] == true);
        _;
    }

    function initialize() public initializer {
        __Ownable_init();

        __ERC20_init("bUKHI", "bUKH");

        _mint(owner(), INITIAL_SUPPLY);

        minters[owner()] = true;
    }

    function addMinter(address _minter) external onlyOwner {
        require(_minter != address(0x0));
        minters[_minter] = true;
    }

    function removeMinter(address _minter) external onlyOwner {
        require(_minter != address(0x0));
        minters[_minter] = false;
    }

    function mint(address _to, uint256 _amount) external onlyMinter {
        _mint(_to, _amount);
    }

    function burn(address _account, uint256 _amount) external onlyMinter {
        _burn(_account, _amount);
    }
}
