pragma solidity >=0.5.0;

import "./SafeMath.sol";

/**
 * @dev Interface of the POR (Proof Of Reserve) standard as defined below.
 */
interface IProofOfReserve {

    /**
     * @dev Returns the amount of asset tokens in the contracts reserve.
     */
    function reserve() external view returns (uint256);

    /**
     * @dev Returns the current amount of tokens in the contracts reserve.
     */
    function exchangeRate() external view returns (uint256);

    /**
     * @dev Returns the number of basis Points used by the contract as ratio representation.
     * For example, if `basisPoint` equals `3`, a `depositFeePoints` of `25` represents a
     * deposit fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (FeePoints * 100/ (10 ** basisPoint)).     
     */
    function basisPoint() external view returns (uint8);

    /**
     * @dev Returns the depositFeePoints of the contract.
     * For example, if `basisPoint` equals `3`, a `depositFeePoints` of `25` represents a
     * deposit fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (depositFeePoints * 100/ (10 ** basisPoint)).
     */
    function depositFeePoints() external view returns (uint256);

    /**
     * @dev Returns the withdrawFeePoints of the contract.
     * For example, if `basisPoint` equals `3`, a `withdrawFeePoints` of `25` represents a
     * withdraw fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (withdrawFeePoints * 100/ (10 ** basisPoint)).
     */
    function withdrawFeePoints() external view returns (uint256);

    /**
     * @dev Returns the maxSettableFeePoints of the contract.
     * For example, if `basisPoint` equals `3`, a `maxSettableFeePoints` of `25` represents a
     * max settable fee of 2.5% (per cent or percentage) and should
     * be displayed to a user as `2.5%` by the formula (maxSettableFeePoints * 100/ (10 ** basisPoint)).
     */
    function maxSettableFeePoints() external view returns (uint256);

    /*************************************************************
     *  WRITE METHODS
    **************************************************************/

    /**
     * @dev See {IProofOfReserve-reserve}.
     */
    function deposit() external payable returns (bool);

    /**
     * @dev See {IProofOfReserve-reserve}.
     */
    function withdraw(uint256 amount) external returns (bool);
    
    /*************************************************************
     *  EVENT METHODS
    **************************************************************/

    /**
     * @dev Emitted when `value` of reserve-asset tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event AssetTransfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @dev Optional functions from the TRC20 standard.
 */
contract ProofOfReserve is IProofOfReserve {

    using SafeMath for uint256;

    uint8 private BASIS_POINT;

    uint256 private DEPOSIT_FEE_POINTS;

    uint256 private WITHDRAW_FEE_POINTS;

    uint256 private MAX_SETTABLE_FEE_POINTS;

    uint256 private INITIAL_EXCHANGE_RATE;

    uint256 private LAUNCH_TIME;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (uint8 POR_BASIS_POINT, uint256 POR_DEPOSIT_FEE_POINTS, uint256 POR_WITHDRAW_FEE_POINTS, uint256 POR_MAX_SETTABLE_FEE_POINTS, uint256 LAUNCHTIME) internal {
        BASIS_POINT = POR_BASIS_POINT;
        DEPOSIT_FEE_POINTS = POR_DEPOSIT_FEE_POINTS;
        WITHDRAW_FEE_POINTS = POR_WITHDRAW_FEE_POINTS;
        MAX_SETTABLE_FEE_POINTS = POR_MAX_SETTABLE_FEE_POINTS;
        LAUNCH_TIME = LAUNCHTIME;
    }

    /*************************************************************
     *  MODIFIER METHODS
    **************************************************************/

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyIfLaunched() {
        require(now >= LAUNCH_TIME, "ProofOfReserve: Not yet Launched!");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyIfNotLaunched() {
        require(now < LAUNCH_TIME, "ProofOfReserve: Already Launched!");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier feePointsRangeCheck(uint256 FEE_POINTS) {
        require(MAX_SETTABLE_FEE_POINTS >= FEE_POINTS, "ProofOfReserve: FEE_POINTS out of range error.");
        _;
    }

    /*************************************************************
     *  READ METHODS
    **************************************************************/

    /**
     * @dev See {IProofOfReserve-reserve}.
     */
    function reserve() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev See {IProofOfReserve-basisPoint}.
     */
    function basisPoint() public view returns (uint8) {
        return BASIS_POINT;
    }

    /**
     * @dev See {IProofOfReserve-depositFeePoints}.
     */
    function depositFeePoints() public view returns (uint256) {
        return DEPOSIT_FEE_POINTS;
    }

    /**
     * @dev See {IProofOfReserve-withdrawFeePoints}.
     */
    function withdrawFeePoints() public view returns (uint256) {
        return WITHDRAW_FEE_POINTS;
    }

    /**
     * @dev See {IProofOfReserve-withdrawFeePoints}.
     */
    function maxSettableFeePoints() public view returns (uint256) {
        return MAX_SETTABLE_FEE_POINTS;
    }
    
    /*************************************************************
     *  INTERNAL METHODS
    **************************************************************/

    /**
     * @dev Updates the `depositFeePoints` of the contract.
     */
    function _updateDepositFeePoints(uint256 FEE_POINTS) internal {
        DEPOSIT_FEE_POINTS = FEE_POINTS;
    }

    /**
     * @dev Updates the `withdrawFeePoints` of the contract.
     */
    function _updateWithdrawFeePoints(uint256 FEE_POINTS) internal {
        WITHDRAW_FEE_POINTS = FEE_POINTS;
    }
    
}