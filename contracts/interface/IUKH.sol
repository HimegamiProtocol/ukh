pragma solidity 0.6.12;

interface IUKH {
    function addMinter(address _minter) external;

    function removeMinter(address _minter) external;

    function setPaused(bool _paused) external;

    function isPaused() external view returns (bool);

    function mint(address _to, uint256 _amount) external;

    function burn(address _account, uint256 _amount) external;
}
