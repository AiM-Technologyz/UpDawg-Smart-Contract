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
    constructor(uint256 BasicTokenInitialSupply) public {
        _mint(_msgSender(), BasicTokenInitialSupply);
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
    constructor(
        string memory TRC20DetailedTokenName,
        string memory TRC20DetailedTokenSymbol,
        uint8 TRC20DetailedTokenDecimals,
        uint256 BasicTokenInitialSupply
    )
        public
        TRC20Detailed(
            TRC20DetailedTokenName,
            TRC20DetailedTokenSymbol,
            TRC20DetailedTokenDecimals
        )
        BasicToken(
            BasicTokenInitialSupply * (10**uint256(TRC20DetailedTokenDecimals))
        )
    {}
}

/**
 * @title StandardTokenWithHodl
 * @dev The Standard TRC20 Token, with the hodler's pool.
 */
contract StandardTokenWithHodl is StandardToken, TRC20Hodl {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(
        string memory StandardTokenTokenName,
        string memory StandardTokenTokenSymbol,
        uint8 StandardTokenTokenDecimals,
        uint256 StandardTokenInitialSupply,
        uint256 TRC20HodlClaimPeriod
    )
        public
        TRC20Hodl(TRC20HodlClaimPeriod)
        StandardToken(
            StandardTokenTokenName,
            StandardTokenTokenSymbol,
            StandardTokenTokenDecimals,
            StandardTokenInitialSupply
        )
    {}

    /*************************************************************
     *  READ METHODS
     **************************************************************/

    /**
     * @dev See {ITRC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return circulatingSupply().add(hodlSupply());
    }

    /*************************************************************
     *  WRITE METHODS
     **************************************************************/

    /**
     * @dev See {ITRC20-transfer}.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        (uint256 reward, uint256 inflation) = _claimReward(
            _msgSender(),
            balanceOf(_msgSender()),
            totalSupply()
        );
        _mint(_msgSender(), reward.add(inflation));
        (uint256 reward2, uint256 inflation2) = _claimReward(
            recipient,
            balanceOf(recipient),
            totalSupply()
        );
        _mint(recipient, reward2.add(inflation2));
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {ITRC20-transferFrom}.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        (uint256 reward, uint256 inflation) = _claimReward(
            sender,
            balanceOf(sender),
            totalSupply()
        );
        _mint(sender, reward.add(inflation));
        (uint256 reward2, uint256 inflation2) = _claimReward(
            recipient,
            balanceOf(recipient),
            totalSupply()
        );
        _mint(recipient, reward2.add(inflation2));
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            allowance(sender, _msgSender()).sub(amount)
        );
        return true;
    }

    /**
     * @dev See {ITRC20Hodl-claimReward}.
     */
    function claimReward()
        public
        returns (
            bool,
            uint256,
            uint256
        )
    {
        (uint256 reward, uint256 inflation) = _claimReward(
            _msgSender(),
            balanceOf(_msgSender()),
            totalSupply()
        );
        _mint(_msgSender(), reward.add(inflation));
        return (true, reward, inflation);
    }

    /**
     * @dev See {ITRC20Hodl-donateReward}.
     */
    function donateReward(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        _mintHodl(amount);
        return true;
    }
}

/**
 * @title PORToken
 * @dev Very basic TRC20 Token, with the optional requirements of the TRC20 standards.
 * All tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 */
contract PORToken is StandardTokenWithHodl, POR {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(
        string memory STWHTokenName,
        string memory STWHTokenSymbol,
        uint8 STWHTokenDecimals,
        uint256 STWHInitialSupply,
        uint256 STWHClaimPeriod,
        uint8 PORBasisPoint,
        uint256 PORbuyFees,
        uint256 PORsellFees,
        uint256 PORMaxFees,
        uint256 PORMinFees,
        uint256 PORLaunchTime
    )
        public
        POR(
            PORBasisPoint,
            PORbuyFees,
            PORsellFees,
            PORMaxFees,
            PORMinFees,
            PORLaunchTime
        )
        StandardTokenWithHodl(
            STWHTokenName,
            STWHTokenSymbol,
            STWHTokenDecimals,
            STWHInitialSupply,
            STWHClaimPeriod
        )
    {}

    /*************************************************************
     *  READ METHODS
     **************************************************************/

    /**
     * @dev See {IPOR-exchangeRate}.
     */
    function exchangeRate() public view returns (uint256) {
        return totalSupply().mul(1_000_000).div(reserve());
    }

    /*************************************************************
     *  WRITE METHODS
     **************************************************************/

    /**
     * @dev Updates the `buyFees` of the contract.
     */
    function updateBuyFees(uint256 FEE_POINTS)
        public
        onlyOwner
        feePointsRangeCheck(FEE_POINTS)
        returns (bool)
    {
        _updateBuyFees(FEE_POINTS);
        return true;
    }

    /**
     * @dev Updates the `sellFees` of the contract.
     */
    function updateSellFees(uint256 FEE_POINTS)
        public
        onlyOwner
        feePointsRangeCheck(FEE_POINTS)
        returns (bool)
    {
        _updateSellFees(FEE_POINTS);
        return true;
    }

    /**
     * @dev See {IPOR-buy}.
     */
    function buy() public payable onlyIfLaunched returns (bool) {
        (uint256 reward, uint256 inflation) = _claimReward(
            _msgSender(),
            balanceOf(_msgSender()),
            totalSupply()
        );
        _mint(_msgSender(), reward.add(inflation));
        _buy(_msgSender(), msg.value);
        return true;
    }

    /**
     * @dev See {IPOR-sell}.
     */
    function sell(uint256 amount) public onlyIfLaunched returns (bool) {
        (uint256 reward, uint256 inflation) = _claimReward(
            _msgSender(),
            balanceOf(_msgSender()),
            totalSupply()
        );
        _mint(_msgSender(), reward.add(inflation));
        _sell(_msgSender(), amount);
        return true;
    }

    /**
     * @dev airDropClaim.
     */
    function airDropClaim() public onlyIfNotLaunched returns (bool) {
        (uint256 reward, uint256 inflation) = _claimReward(
            _msgSender(),
            balanceOf(_msgSender()),
            totalSupply()
        );
        _mint(_msgSender(), reward.add(inflation));
        _mint(_msgSender(), 21 * (10**6) * (10**uint256(decimals())));
        return true;
    }

    /*************************************************************
     *  INTERNAL METHODS
     **************************************************************/

    /**
     * @dev See {IPOR-buy}.
     */
    function _buy(address account, uint256 amount) internal {
        require(account != address(0), "POR: recipient is the zero address.");
        require(
            amount <= reserve(),
            "POR: Insufficient Backing Asset (TRX) Balance!"
        );

        uint256 INITIAL_ASSET_RESERVE = reserve().sub(amount);
        uint256 INITIAL_TOKEN_SUPPLY = totalSupply();
        uint256 FINAL_ASSET_RESERVE = reserve();
        uint256 FINAL_TOKEN_SUPPLY = INITIAL_TOKEN_SUPPLY
            .mul(FINAL_ASSET_RESERVE)
            .div(INITIAL_ASSET_RESERVE);
        uint256 WEIGHT_PRICE_VOL = FINAL_TOKEN_SUPPLY.sub(INITIAL_TOKEN_SUPPLY);

        uint256 FEE = WEIGHT_PRICE_VOL.mul(buyFees());
        FEE = FEE.div(1 * (10**uint256(basisPoint())));

        uint256 PROCESSED_VOL = WEIGHT_PRICE_VOL.sub(FEE);
        _mint(account, PROCESSED_VOL);

        if (owner() != address(0)) {
            (uint256 reward, uint256 inflation) = _claimReward(
                owner(),
                balanceOf(owner()),
                totalSupply()
            );
            _mint(owner(), (FEE.mul(3).div(5)).add(reward).add(inflation));
        }
        _mintHodl(FEE.div(5));
        emit AssetTransfer(account, address(this), amount);
    }

    /**
     * @dev See {IPOR-sell}.
     */
    function _sell(address account, uint256 amount) internal {
        require(account != address(0), "POR: account is the zero address.");
        require(
            amount <= balanceOf(account).mul(90).div(100),
            "POR: account is the zero address."
        );

        uint256 FEE = amount.mul(sellFees());
        FEE = FEE.div(1 * (10**uint256(basisPoint())));

        uint256 PROCESSED_VOL = amount.sub(FEE);

        uint256 INITIAL_ASSET_RESERVE = reserve();
        uint256 INITIAL_TOKEN_SUPPLY = totalSupply();
        uint256 FINAL_TOKEN_SUPPLY = INITIAL_TOKEN_SUPPLY.sub(PROCESSED_VOL);
        uint256 FINAL_ASSET_RESERVE = FINAL_TOKEN_SUPPLY
            .mul(INITIAL_ASSET_RESERVE)
            .div(INITIAL_TOKEN_SUPPLY);
        uint256 sell_AMT = INITIAL_ASSET_RESERVE.sub(FINAL_ASSET_RESERVE);

        uint256 BURN_VOL = FEE.mul(2).div(4);
        BURN_VOL = BURN_VOL.add(PROCESSED_VOL);

        if (owner() != address(0)) {
            (uint256 reward, uint256 inflation) = _claimReward(
                owner(),
                balanceOf(owner()),
                totalSupply()
            );
            _mint(owner(), reward.add(inflation));
            _transfer(account, owner(), FEE.mul(3).div(5));
        } else {
            BURN_VOL = amount;
        }
        _burn(account, BURN_VOL);
        _mintHodl(FEE.div(5));

        address payable PAY_ACCOUNT = address(uint160(account));
        PAY_ACCOUNT.transfer(sell_AMT);
        //PAY_ACCOUNT.call().value(sell_AMT)();
        emit AssetTransfer(address(this), account, sell_AMT);
    }
}

/**
 * @title UpDawg
 * @dev The UpDawg Token (UDAWG), is a proof of reserve token overriding the TRC20 token standards.
 */
contract UpDawg is PORToken {
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor(
        string memory TokenName,
        string memory TokenSymbol,
        uint8 TokenDecimals,
        uint256 InitialSupply,
        uint256 ClaimPeriod,
        uint8 BasisPoint,
        uint256 BuyFees,
        uint256 SellFees,
        uint256 MaxFees,
        uint256 MinFees,
        uint256 LaunchTime
    )
        public
        payable
        PORToken(
            TokenName,
            TokenSymbol,
            TokenDecimals,
            InitialSupply,
            ClaimPeriod,
            BasisPoint,
            BuyFees,
            SellFees,
            MaxFees,
            MinFees,
            LaunchTime
        )
    {}
}