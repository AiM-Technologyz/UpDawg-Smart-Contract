pragma solidity >=0.5.0;

import "./SafeMath.sol";

/**
 * @dev Interface of the POR (Proof Of Reserve) standard as defined below.
 */
interface IPOR {
    /**
     * @dev Returns the amount of TRX in the contracts reserve.
     */
    function reserve() external view returns (uint256);

    /**
     * @dev Returns the current amount of tokens in the contracts reserve.
     */
    function exchangeRate() external view returns (uint256);

    /**
     * @dev Returns the number of basis Points used by the contract as ratio representation.
     * For example, if `basisPoint` equals `3`, a `buyFees` of `25` represents a
     * buy fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (FeePoints * 100/ (10 ** basisPoint)).
     */
    function basisPoint() external view returns (uint8);

    /**
     * @dev Returns the buyFees of the contract.
     * For example, if `basisPoint` equals `3`, a `buyFees` of `25` represents a
     * buy fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (buyFees * 100/ (10 ** basisPoint)).
     */
    function buyFees() external view returns (uint256);

    /**
     * @dev Returns the sellFees of the contract.
     * For example, if `basisPoint` equals `3`, a `sellFees` of `25` represents a
     * sell fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (sellFees * 100/ (10 ** basisPoint)).
     */
    function sellFees() external view returns (uint256);

    /**
     * @dev Returns the maxFees of the contract.
     * For example, if `basisPoint` equals `3`, a `maxFees` of `25` represents a
     * max settable fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (maxFees * 100/ (10 ** basisPoint)).
     */
    function maxFees() external view returns (uint256);

    /**
     * @dev Returns the minFees of the contract.
     * For example, if `basisPoint` equals `3`, a `minFees` of `25` represents a
     * max settable fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (minFees * 100/ (10 ** basisPoint)).
     */
    function minFees() external view returns (uint256);

    /*************************************************************
     *  WRITE METHODS
     **************************************************************/

    /**
     * @dev See {IPOR-reserve}.
     */
    function buy() external payable returns (bool);

    /**
     * @dev See {IPOR-reserve}.
     */
    function sell(uint256 amount) external returns (bool);

    /*************************************************************
     *  EVENT METHODS
     **************************************************************/

    /**
     * @dev Emitted when `value` of reserve-asset tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event AssetTransfer(
        address indexed from,
        address indexed to,
        uint256 value
    );
}

/**
 * @dev Implementation of the {IPOR} interface.
 */
contract POR is IPOR {
    using SafeMath for uint256;

    uint8 private BASIS_POINT;

    uint256 private BUY_FEES;

    uint256 private SELL_FEES;

    uint256 private MAX_FEES;

    uint256 private MIN_FEES;

    uint256 private LAUNCH_TIME;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor(
        uint8 POR_BASIS_POINT,
        uint256 POR_BUY_FEES,
        uint256 POR_SELL_FEES,
        uint256 POR_MAX_FEES,
        uint256 POR_MIN_FEES,
        uint256 LAUNCHTIME
    ) internal {
        BASIS_POINT = POR_BASIS_POINT;
        BUY_FEES = POR_BUY_FEES;
        SELL_FEES = POR_SELL_FEES;
        MAX_FEES = POR_MAX_FEES;
        MIN_FEES = POR_MIN_FEES;
        LAUNCH_TIME = LAUNCHTIME;
    }

    /*************************************************************
     *  MODIFIER METHODS
     **************************************************************/

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyIfLaunched() {
        require(now >= LAUNCH_TIME, "POR: Not yet Launched!");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyIfNotLaunched() {
        require(now < LAUNCH_TIME, "POR: Already Launched!");
        _;
    }

    /**
     * @dev Throws if `FEE_POINTS` is greater than `maxFees` or less than `minFees`.
     */
    modifier feePointsRangeCheck(uint256 FEE_POINTS) {
        require(
            FEE_POINTS <= maxFees(),
            "POR Out_Of_Range ERROR: FEE_POINTS is greater than `maxFees`."
        );
        require(
            FEE_POINTS >= minFees(),
            "POR Out_Of_Range ERROR: FEE_POINTS is less than `minFees`."
        );
        _;
    }

    /*************************************************************
     *  READ METHODS
     **************************************************************/

    /**
     * @dev See {IPOR-reserve}.
     */
    function reserve() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev See {IPOR-basisPoint}.
     */
    function basisPoint() public view returns (uint8) {
        return BASIS_POINT;
    }

    /**
     * @dev See {IPOR-buyFees}.
     */
    function buyFees() public view returns (uint256) {
        return BUY_FEES;
    }

    /**
     * @dev See {IPOR-sellFees}.
     */
    function sellFees() public view returns (uint256) {
        return SELL_FEES;
    }

    /**
     * @dev See {IPOR-maxFees}.
     */
    function maxFees() public view returns (uint256) {
        return MAX_FEES;
    }

    /**
     * @dev See {IPOR-minFees}.
     */
    function minFees() public view returns (uint256) {
        return MIN_FEES;
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
}
