pragma solidity >=0.5.0;

import "./SafeMath.sol";

/**
 * @dev Optional functions from the TRC20 standard.
 */
contract POR {

    using SafeMath for uint256;

    uint8 private BASIS_POINT = 4;

    uint256 private BUY_FEES;

    uint256 private SELL_FEES;

    uint256 private LAUNCH_TIME;

    /**
     * @dev Sets the values for `basisPoint`, `buyFees`, `sellFees`, `maxFees` and `minFees`. Out of these five, three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (uint256 LAUNCHTIME) internal {
        LAUNCH_TIME = LAUNCHTIME;
        _calibrateFees();
    }

    /*************************************************************
     *  MODIFIER METHODS
    **************************************************************/

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyIfLaunched() {
        require(now >= LAUNCH_TIME, "ProofOfReserve: Launchpad in progress. Complete contract not yet Launched!");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyIfNotLaunched() {
        require(now < LAUNCH_TIME, "ProofOfReserve: Launchpad has ended. Complete contract Launched!");
        _;
    }

    /*************************************************************
     *  READ METHODS
    **************************************************************/

    /**
     * @dev Returns the amount of asset tokens in the contracts reserve.
     */
    function reserve() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Returns the number of basis Points used by the contract as ratio representation.
     * For example, if `basisPoint` equals `3`, a `buyFees` of `25` represents a
     * deposit fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (FeePoints * 100/ (10 ** basisPoint)).     
     */
    function basisPoint() public view returns (uint8) {
        return BASIS_POINT;
    }

    /**
     * @dev Returns the buyFees of the contract.
     * For example, if `basisPoint` equals `3`, a `buyFees` of `25` represents a
     * deposit fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (buyFees * 100/ (10 ** basisPoint)).
     */
    function buyFees() public view returns (uint256) {
        return BUY_FEES;
    }

    /**
     * @dev Returns the sellFees of the contract.
     * For example, if `basisPoint` equals `3`, a `sellFees` of `25` represents a
     * withdraw fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (sellFees * 100/ (10 ** basisPoint)).
     */
    function sellFees() public view returns (uint256) {
        return SELL_FEES;
    }
    
    /*************************************************************
     *  INTERNAL METHODS
    **************************************************************/

    /**
     * @dev Checks the reserve and Updates the fees of the contract.
     */
    function _calibrateFees() internal {
        if (reserve() >= 0 && reserve() < 1 * (10 ** 6)) {
            _updateBuyFees(100);
            _updateSellFees(1000);
        } else if (reserve() >= 1 * (10 ** 6) && reserve() < 10 * (10 ** 6)) {            
            _updateBuyFees(90);
            _updateSellFees(900);
        } else if (reserve() >= 10 * (10 ** 6) && reserve() < 100 * (10 ** 6)) {            
            _updateBuyFees(80);
            _updateSellFees(800);
        } else if (reserve() >= 100 * (10 ** 6) && reserve() < 1000 * (10 ** 6)) {            
            _updateBuyFees(70);
            _updateSellFees(700);
        } else if (reserve() >= 1000 * (10 ** 6) && reserve() < 10_000 * (10 ** 6)) {            
            _updateBuyFees(60);
            _updateSellFees(600);
        } else if (reserve() >= 10_000 * (10 ** 6) && reserve() < 100_000 * (10 ** 6)) {            
            _updateBuyFees(50);
            _updateSellFees(500);
        } else if (reserve() >= 100_000 * (10 ** 6) && reserve() < 1_000_000 * (10 ** 6)) {            
            _updateBuyFees(40);
            _updateSellFees(400);
        } else if (reserve() >= 1_000_000 * (10 ** 6) && reserve() < 10_000_000 * (10 ** 6)) {            
            _updateBuyFees(30);
            _updateSellFees(300);
        } else if (reserve() >= 10_000_000 * (10 ** 6) && reserve() < 100_000_000 * (10 ** 6)) {            
            _updateBuyFees(20);
            _updateSellFees(200);
        } else if (reserve() >= 100_000_000 * (10 ** 6) && reserve() < 1_000_000_000 * (10 ** 6)) {            
            _updateBuyFees(10);
            _updateSellFees(100);
        } else if (reserve() >= 1_000_000_000 * (10 ** 6)) {            
            _updateBuyFees(9);
            _updateSellFees(90);
        }
    }

    /**
     * @dev Updates the `buyFees` of the contract.
     */
    function _updateBuyFees(uint256 FEE_POINTS) internal {
        BUY_FEES = FEE_POINTS;
    }

    /**
     * @dev Updates the `sellFees` of the contract.
     */
    function _updateSellFees(uint256 FEE_POINTS) internal {
        SELL_FEES = FEE_POINTS;
    }
        
    /*************************************************************
     *  EVENT METHODS
    **************************************************************/

    /**
     * @dev Emitted when `value` of reserve-asset (TRX) are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event AssetTransfer(address indexed from, address indexed to, uint256 value);
}