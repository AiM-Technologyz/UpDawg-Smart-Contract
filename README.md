# UpDawg Smart Contract

Satoshi Nakamoto -

> “If you don't believe me or don't get it, I don't have time to try to convince you, sorry.”

<hr>

## What is UpDawg?
UpDawg is a TRC20 smart contract on the TRON blockchain. The smart contract consists of a token(UDAWG) with an in-built DEX(dawgDEX). UDAWG is a Proof Of Reserve token backed by TRX. UDAWG can be purchased & sold on the dawgDEX.

## Technology
Once deployed on the blockchain, the Launchpad will be in effect and initially the TRX Reserve will have 0.000001 TRX sent by DawgDAO in exchange for 21 UDAWG tokens to set the price of UDAWG tokens as : 21 Million UDAWG = 1 TRX.

## Launchpad
Once deployed on the blockchain, the Launchpad will be in effect and initially the TRX Reserve will have 1 TRX sent by DawgDAO in exchange for 21 million UDAWG tokens to set the price of UDAWG tokens as : 21 Million UDAWG = 1 TRX.

## Price Formula
The price formula of UDAWG token =
(Total Supply of UDAWG Token) / (Total TRX in UpDawg Reserve)

## dawgDEX
The conclusion of Launchpad marks the inception of the dawgDEX. The exchange fee will be set at 1% for purchasing tokens and 10% for selling tokens. The exchange fee will automatically change based on the TRX reserve of the UpDawg contract, according to the below Fee Schedule.

## Fee schedule

The Transaction Fee Distribution is as follows :

- 0 TRX <= Reserve < 1 TRX      :       
  - 1% Deposit Fee;
  - 10% Withdraw Fee;

- 1 TRX <= Reserve < 10 TRX     :
  - 0.9% Deposit Fee;
  - 9% Withdraw Fee;

- 10 TRX <= Reserve < 100 TRX	  :
  - 0.8% Deposit Fee;
  - 8% Withdraw Fee;

- 100 TRX <= Reserve < 1k TRX   :
  - 0.7% Deposit Fee;
  - 7% Withdraw Fee;

- 1k TRX <= Reserve < 10k TRX	  :
  - 0.6% Deposit Fee;
  - 6% Withdraw Fee;

- 10k TRX <= Reserve < 100k TRX	:
  - 0.5% Deposit Fee;
  - 5% Withdraw Fee;

- 100k TRX <= Reserve < 1M TRX	:
  - 0.4% Deposit Fee;
  - 4% Withdraw Fee;

- 1M TRX <= Reserve < 10M TRX	  :
  - 0.3% Deposit Fee;
  - 3% Withdraw Fee;

- 10M TRX <= Reserve < 100M TRX	:
  - 0.2% Deposit Fee;
  - 2% Withdraw Fee;

- 100M TRX <= Reserve < 1B TRX	:
  - 0.1% Deposit Fee;
  - 1% Withdraw Fee;

- Reserve >= 1B TRX	            :
  - 0.09% Deposit Fee;
  - 0.9% Withdraw Fee;

## Functions
The UpDawg smart contract implements the standard TRC20 functions along with the following additional functions :

### Total Supply :
This function returns the total supply of the token.


### Balance Of :
This function returns the amount of tokens owned by the specific `account`.
```

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

```


### Buy : 
This function will transfer user specified TRX to the UpDAWG smart contract address , and mint UDAWG on the user address depending on the current price stated on dawgDEX


### Sell : 
This function will Burn user specified UDAWG , and transfer TRX to the user address depending on the current price stated on dawgDEX. At any given time, only 90% of UDAWG can be sold on dawgDEX.


### Burn : 
This operation can burn any number of UDAWG tokens.


### Claim Reward : 
This function will allow HODLers to claim their share from HODLersPool and mint 0.01% new tokens of their reward.


### Transfer : 
transferring UDAWG will also execute the ‘Claim Reward’ function for both the sender & receiver.


### Donate Reward :
This function allows anyone to send UDAWG to HODLersPool.


### Claim Airdrop :
This function will be functional only during the Launchpad. It will allow users to mint 1 million UDAWG tokens per claim.


Every function will be executed by using the TronLink extension directly from the official [TRON Blockchain Explorer website](https://tronscan.org/#/), protected by TLS. TRON blockchain native token (TRX) will be used for implementing UpDAWG operations. Generally fee will be less than 40 TRX and can be laid down to 0 TRX if the user has sufficient Energy & bandwidth available.


## Transparency
The UpDAWG smart contract manages the UDAWG token & the TRX reserve, ensuring a fully decentralised & trustless process. Contract owner can not interfere with the smart contract’s specifications except for 2 predetermined functions(updateBuyFee &updateSellFee), hard coded in the smart contract code, as the code is open source.

<hr>

There is no method in the UpDAWG smart contract to withdraw the TRX Reserve or UDAWG HODLpool. The internal reserves in the smart contract is viewable to make sure token value is backed by the expected amount of collateral.
To look into the reserve users can visit UpDAWG website or TRON blockchain explorer, as UpDAWG is an TRC20 smart contract all the reserves are on-chain.

To ensure no chance of scam or security risk, the UpDAWG smart contract will be audited.

<br>

<br>

Satoshi Nakamoto -

> “We shouldn’t delay forever until every possible feature is done. There’s always going to be one more thing to do.”

<br>

<br>

<hr>