pragma solidity >=0.5.0;

import "./SafeMath.sol";

/**
 * @dev Optional functions from the TRC20 standard.
 */
contract POR {

    using SafeMath for uint256;

    uint8 private BASIS_POINT;

    uint256 private BUY_FEES;

    uint256 private SELL_FEES;

    uint256 private MAX_FEES;

    uint256 private LAUNCH_TIME;

    /**
     * @dev Sets the values for `basisPoint`, `buyFees`, `sellFees`, `maxFees` and `minFees`. Out of these five, three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (uint8 POR_BASIS_POINT, uint256 POR_BUY_FEES, uint256 POR_WITHDRAW_FEE_POINTS, uint256 POR_MAX_FEES, uint256 LAUNCHTIME) internal {
        BASIS_POINT = POR_BASIS_POINT;
        BUY_FEES = POR_BUY_FEES;
        SELL_FEES = POR_WITHDRAW_FEE_POINTS;
        MAX_FEES = POR_MAX_FEES;
        LAUNCH_TIME = LAUNCHTIME;
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

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier feePointsRangeCheck(uint256 FEE_POINTS) {
        require(FEE_POINTS <= maxFees() && FEE_POINTS > 0, "ProofOfReserve: FEE_POINTS out of range error.");
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

    /**
     * @dev Returns the maxFees of the contract.
     * For example, if `basisPoint` equals `3`, a `maxFees` of `25` represents a
     * max settable fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (maxFees * 100/ (10 ** basisPoint)).
     */
    function maxFees() public view returns (uint256) {
        return MAX_FEES;
    }
    
    /*************************************************************
     *  INTERNAL METHODS
    **************************************************************/

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