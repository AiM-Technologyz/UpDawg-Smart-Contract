// 0.5.1-c8a2
// Enable optimization
pragma solidity >=0.5.0;

import "./TRC20.sol";
import "./TRC20Detailed.sol";
import "./TRC20Hodl.sol";
import "./POR.sol";

/**
 * @title BasicToken
 * @dev Very basic TRC20 Token, without the optional requirements of the TRC20 standards.
 * All tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 * Note Initial Supply can be set to zero in case where a miniting mechanism is defined
 * in deriving contracts.
 */
contract BasicToken is TRC20 {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(uint256 TRC20InitialSupply) public {
        _mint(_msgSender(), TRC20InitialSupply);
    }
}








/**
 * @title StandardToken
 * @dev The Standard TRC20 Token, with the optional requirements of the TRC20 standards.
 */
contract StandardToken is BasicToken, TRC20Detailed {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(string memory TRC20DetailedTokenName, string memory TRC20DetailedTokenSymbol, uint8 TRC20DetailedTokenDecimals, uint256 BasicTokenInitialSupply) public TRC20Detailed(TRC20DetailedTokenName, TRC20DetailedTokenSymbol, TRC20DetailedTokenDecimals) BasicToken(BasicTokenInitialSupply * (10 ** uint256(TRC20DetailedTokenDecimals))) {

    }
}








/**
 * @title StandardTokenWithHodl
 * @dev The Standard TRC20 Token, with the hodler's pool.
 */
contract StandardTokenWithHodl is StandardToken, TRC20Hodl {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(string memory StandardTokenTokenName, string memory StandardTokenTokenSymbol, uint8 StandardTokenTokenDecimals, uint256 StandardTokenInitialSupply, uint256 TRC20HodlClaimPeriod) public TRC20Hodl(TRC20HodlClaimPeriod) StandardToken(StandardTokenTokenName, StandardTokenTokenSymbol, StandardTokenTokenDecimals, StandardTokenInitialSupply) {
        
    }

    /*************************************************************
     *  READ METHODS
    **************************************************************/

    function totalSupply() public view returns (uint256) {
        return circulatingSupply().add(hodlSupply());
    }

    /*************************************************************
     *  WRITE METHODS
     **************************************************************/

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _claimReward(_msgSender());
        _claimReward(recipient);
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _claimReward(sender);
        _claimReward(recipient);
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount));
        return true;
    }

    function claimReward() public returns (bool) {
        _claimReward(_msgSender());
        return true;
    }

    function donateReward(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        _mintHodl(amount);
        return true;
    }

     /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     */
    function burn(uint256 amount) public returns (bool) {
        _claimReward(_msgSender());
        _burn(_msgSender(), amount);
        return true;
    }

    /*************************************************************
     *  INTERNAL METHODS
     **************************************************************/

    function _claimReward(address account) internal {
        require(account != address(0), "ProofOfReserve: account is the zero address.");

        if (prevClaimOf(account) == 0) {
            _updatePrevClaimOf(account);
        } else {
            uint256 duration = now.sub(prevClaimOf(account));
            uint256 reward = duration.mul(balanceOf(account));
            reward = reward.mul(hodlSupply());
            reward = reward.div(claimPeriod());
            reward = reward.div(totalSupply());

            uint256 inflation = reward.div(10000);

            //Reward overflow check.
            if (reward >= hodlSupply()) {
                _burnHodl(hodlSupply());
                _mint(account, hodlSupply().add(inflation));
            } else {
                _burnHodl(reward);
                _mint(account, reward.add(inflation));
            }
            _updatePrevClaimOf(account);
        }
    }
}

/**
 * @title StandardToken
 * @dev Very basic TRC20 Token, with the optional requirements of the TRC20 standards.
 * All tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 */
contract PORToken is StandardTokenWithHodl, POR {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(string memory STWHTokenName, string memory STWHTokenSymbol, uint8 STWHTokenDecimals, uint256 STWHInitialSupply, uint256 STWHClaimPeriod, uint256 PORLaunchTime) public POR(PORLaunchTime) StandardTokenWithHodl(STWHTokenName, STWHTokenSymbol, STWHTokenDecimals, STWHInitialSupply, STWHClaimPeriod) {}

    /*************************************************************
     *  READ METHODS
     **************************************************************/

    /**
     * @dev Returns the current amount of tokens in the contracts reserve.
     */
    function exchangeValue(uint256 TRXamount) public view returns (uint256) {
        return totalSupply().mul(TRXamount).div(reserve());
    }

    /*************************************************************
     *  WRITE METHODS
     **************************************************************/

    function airDropClaim() public onlyIfNotLaunched returns (bool) {
        _claimReward(_msgSender());
        _mint(_msgSender(), 21 * (10 ** 6) * (10 ** uint256(decimals())));
        return true;
    }

    function buy() public payable onlyIfLaunched returns (bool) {
        _claimReward(_msgSender());
        _buy(_msgSender(), msg.value);
        return true;
    }

    function sell(uint256 amount) public onlyIfLaunched returns (bool) {
        _claimReward(_msgSender());
        _sell(_msgSender(), amount);
        return true;
    }

    /*************************************************************
     *  INTERNAL METHODS
     **************************************************************/

    function _buy(address account, uint256 amount) internal {
        require(account != address(0), "ProofOfReserve: account is the zero address.");
        require(amount <= reserve(), "ProofOfReserve: Insufficient TRX Reserve!");

        uint256 INITIAL_ASSET_RESERVE = reserve().sub(amount);
        uint256 INITIAL_TOKEN_SUPPLY = totalSupply();
        uint256 FINAL_ASSET_RESERVE = reserve();
        uint256 FINAL_TOKEN_SUPPLY = INITIAL_TOKEN_SUPPLY.mul(FINAL_ASSET_RESERVE).div(INITIAL_ASSET_RESERVE);
        uint256 WEIGHT_PRICE_VOL = FINAL_TOKEN_SUPPLY.sub(INITIAL_TOKEN_SUPPLY);

        uint256 FEE = WEIGHT_PRICE_VOL.mul(buyFees());
        FEE = FEE.div(1 * (10**uint256(basisPoint())));

        uint256 PROCESSED_VOL = WEIGHT_PRICE_VOL.sub(FEE);

        if(amount.mod(108 * (10 ** 6)) == 0) {
            PROCESSED_VOL = PROCESSED_VOL.mul(101).div(100);
        }

        _mint(account, PROCESSED_VOL);
        if (owner() != address(0)) {
            _claimReward(owner());
            _mint(owner(), FEE.mul(3).div(5));
        }
        _mintHodl(FEE.div(5));
        _calibrateFees();
        emit AssetTransfer(account, address(this), amount);
    }

    function _sell(address account, uint256 amount) internal {
        require(account != address(0), "ProofOfReserve: account is the zero address.");

        uint256 FEE = amount.mul(sellFees());
        FEE = FEE.div(1 * (10**uint256(basisPoint())));

        uint256 PROCESSED_VOL = amount.sub(FEE);

        uint256 INITIAL_ASSET_RESERVE = reserve();
        uint256 INITIAL_TOKEN_SUPPLY = totalSupply();
        uint256 FINAL_TOKEN_SUPPLY = INITIAL_TOKEN_SUPPLY.sub(PROCESSED_VOL);
        uint256 FINAL_ASSET_RESERVE = FINAL_TOKEN_SUPPLY.mul(INITIAL_ASSET_RESERVE).div(INITIAL_TOKEN_SUPPLY);
        uint256 WITHDRAW_AMT = INITIAL_ASSET_RESERVE.sub(FINAL_ASSET_RESERVE);

        uint256 BURN_VOL = FEE.mul(2).div(5);
        BURN_VOL = BURN_VOL.add(PROCESSED_VOL);

        if (owner() != address(0)) {
            _claimReward(owner());
            _transfer(account, owner(), FEE.mul(3).div(5));
        } else {
            BURN_VOL = amount;
        }
        _burn(account, BURN_VOL);
        _mintHodl(FEE.div(5));

        address payable PAY_ACCOUNT = address(uint160(account));
        PAY_ACCOUNT.transfer(WITHDRAW_AMT);
        _calibrateFees();
        emit AssetTransfer(address(this), account, WITHDRAW_AMT);
    }
}

/**
 * @title UpDawg
 * @dev The UpDawg Token, is a proof of reserve token type with the TRC20 standards.
 */
contract UpDawg is PORToken {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(string memory TokenName, string memory TokenSymbol, uint8 TokenDecimals, uint256 InitialSupply, uint256 ClaimPeriod, uint256 LaunchTime) public payable PORToken(TokenName, TokenSymbol, TokenDecimals, InitialSupply, ClaimPeriod, LaunchTime) {

    }

}