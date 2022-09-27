pragma solidity >=0.5.0;

import "./SafeMath.sol";
import "./TRC20.sol";

/**
 * @dev Implementation of the {ITRC20Hodl} interface.
 */
contract TRC20Hodl {
    
    using SafeMath for uint256;

    uint256 private CLAIM_PERIOD;

    mapping (address => uint256) private _prevClaim;
    
    uint256 private _hodlSupply;

    /**
     * @dev Sets the values for `claimPeriod`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (uint256 claim_Period) internal {
        CLAIM_PERIOD = claim_Period;
    }

    /*************************************************************
     *  READ METHODS
    **************************************************************/

    /**
     * @dev Returns the total amount of tokens in hodler pool of the contract.
     */
    function hodlSupply() public view returns (uint256) {
        return _hodlSupply;
    }

    /**
     * @dev Returns the base period for claim rewards.
     */
    function claimPeriod() public view returns (uint256) {
        return CLAIM_PERIOD;
    }
    
    /**
     * @dev Returns the timestamp of previous claim rewards of `account`.
     */
    function prevClaimOf(address account) public view returns (uint256) {
        return _prevClaim[account];
    }

    /*************************************************************
     *  WRITE METHODS
    **************************************************************/

    /*************************************************************
     *  INTERNAL METHODS
    **************************************************************/

    /**
     * @dev Updates the timestamp of the previous
     * claim for `account` to `now`.
     */
    function _updatePrevClaimOf(address account) internal {
        require(account != address(0), "ProofOfReserve: account is the zero address.");

        _prevClaim[account] = now;
    }

    /** @dev Creates `amount` tokens to hodl Supply, increasing
     * the hodl supply.
     *
     * Emits a {HodlTransfer} event with `from` set to the zero address and
     * `to` set to the contract address.
     */
    function _mintHodl(uint256 amount) internal {
        _hodlSupply = _hodlSupply.add(amount);
        emit HodlTransfer(address(0), address(this), amount);
    }

    /**
     * @dev Destroys `amount` tokens from hodl Supply, reducing the
     * hodl Supply.
     *
     * Emits a {HodlTransfer} event with `to` set to the zero address and
     * `from` set to the contract address.
     */
    function _burnHodl(uint256 amount) internal {
        _hodlSupply = _hodlSupply.sub(amount);
        emit HodlTransfer(address(this), address(0), amount);
    }
        
    /*************************************************************
     *  EVENT METHODS
    **************************************************************/

    /**
     * @dev Emitted when `value` hodl Supply tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event HodlTransfer(address indexed from, address indexed to, uint256 value);

}