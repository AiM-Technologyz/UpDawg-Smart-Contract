# UpDawg Smart Contract

<br>
<br>
<hr>
<br>
<br>
<br>
<br>
<br>

**Satoshi Nakamoto -**

> ***“If you don't believe me or don't get it, I don't have time to try to convince you, sorry.”***

<br>
<br>
<br>
<br>
<br>
<hr>
<br>
<br>
<br>
<br>

## What is UpDawg?
UpDawg is a TRC20 smart contract on the TRON blockchain. The smart contract consists of a token(UDAWG) with an in-built DEX(dawgDEX). UDAWG is a Proof Of Reserve token backed by TRX. UDAWG can be purchased & sold on the dawgDEX.

<br>
<br>

## Technology
Once deployed on the blockchain, the Launchpad will be in effect and initially the TRX Reserve will have 0.000001 TRX sent by DawgDAO in exchange for 21 UDAWG tokens to set the price of UDAWG tokens as : 21 Million UDAWG = 1 TRX.

<br>
<br>

## Launchpad
Once deployed on the blockchain, the Launchpad will be in effect and initially the TRX Reserve will have 1 TRX sent by DawgDAO in exchange for 21 million UDAWG tokens to set the price of UDAWG tokens as : 21 Million UDAWG = 1 TRX.

<br>
<br>

## Price Formula
The price formula of UDAWG token =
(Total Supply of UDAWG Token) / (Total TRX in UpDawg Reserve)

<br>
<br>

## dawgDEX
The conclusion of Launchpad marks the inception of the dawgDEX. The exchange fee will be set at 1% for purchasing tokens and 10% for selling tokens. The exchange fee will automatically change based on the TRX reserve of the UpDawg contract, according to the below Fee Schedule.

<br>
<br>

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

<br>
<br>
<br>
<br>

## Functions
The **UpDawg Smart Contract** implements the standard TRC20 functions along with the following additional functions :

<br>
<br>

#### Name
- Function Name: ***name***
- Function Type: ***READ***
- Function Description: ***Returns the name of the `token`. This is an immutable state variable; i.e. It can only be set at the time of deployment and can never be changed. eg. `UpDawg`***
- Function Requirements: ***`-nil-`***
- Function Parameters: ***`-nil-`***
- Function Return: 
  - return[0]: ***[@type: `string`]***
- Function Return Value: ***`UpDawg`***
- Function Signature: 
```
name()
```

<br>
<br>

#### Symbol
- Function Name: ***symbol***
- Function Type: ***READ***
- Function Description: ***Returns the symbol of the token, usually a shorter version of the name. eg. `UDAWG`***
- Function Requirements: ***`-nil-`***
- Function Parameters: ***`-nil-`***
- Function Return: 
  - return[0]: ***[@type: `string`]***
- Function Return Value: ***`UDAWG`***
- Function Signature: 
```
symbol()
```

<br>
<br>

#### Decimals
- Function Name: ***decimals***
- Function Type: ***READ***
- Function Description: ***Returns the number of decimals used to get its user representation. For example, if `decimals` equals `2`, a balance of `505` tokens should be displayed to a user as `5.05` (`505 / 10 ** 2`). Tokens usually opt for a value of 18, imitating the relationship between Ether and Wei.***
- Function Requirements: ***`-nil-`***
- Function Parameters: ***`-nil-`***
- Function Return: 
  - return[0]: ***[@type: `uint8`]***
- Function Return Value: ***`6`***
- Function Signature: 
```
decimals()
```
- Function Note: ***This information is only used for _display_ purposes: it in no way affects any of the arithmetic of the contract, including {ITRC20-balanceOf} and {ITRC20-transfer}.***

<br>
<br>

#### Balance Of
- Function Name: ***balanceOf***
- Function Type: ***READ***
- Function Description: ***This function returns the amount of tokens owned by the specific `account`.***
- Function Requirements: ***`-nil-`***
- Function Parameters: 
  - param1: ***[`account`][@type: `address`]***
- Function Return: 
  - return[0]: ***[@type: `uint256]`***
- Function Signature: 
```
balanceOf(address account)
```
- Function Dev-Note: ***balanceOf***

<br>
<br>

#### Circulating Supply
- Function Name: ***balanceOf***
- Function Type: ***READ***
- Function Description: ***This function returns the amount of tokens owned by the specific `account`.***
- Function Requirements: ***`-nil-`***
- Function Parameters: 
  - param1: ***[`account`][@type: `address`]***
- Function Return: 
  - return[0]: ***[@type: `uint256]`***
- Function Signature: 
```
balanceOf(address account)
```
- Function Dev-Note: ***balanceOf***

<br>
<br>
<br>
<hr>
<br>

Every function will be executed by using the TronLink extension directly from the official [TRON Blockchain Explorer website](https://tronscan.org/#/), protected by TLS. TRON blockchain native token (TRX) will be used for implementing UpDAWG operations. Generally fee will be less than 40 TRX and can be laid down to 0 TRX if the user has sufficient Energy & bandwidth available.

<br>
<br>

## Transparency
The **UpDawg Smart Contract** manages the UDAWG token & the TRX reserve, ensuring a fully decentralised & trustless process. Contract owner can not interfere with the smart contract’s specifications except for 2 predetermined functions(updateBuyFee &updateSellFee), hard coded in the smart contract code, as the code is open source.

<br>
<br>

There is no method in the **UpDawg Smart Contract** to withdraw the TRX Reserve or UDAWG HODLpool. The internal reserves in the smart contract is viewable to make sure token value is backed by the expected amount of collateral.
To look into the reserve users can visit UpDAWG website or TRON blockchain explorer, as UpDAWG is an TRC20 smart contract all the reserves are on-chain.

<br>
<br>

To ensure no chance of scam or security risk, the **UpDawg Smart Contract** will be audited.

<br>
<br>
<hr>
<br>
<br>
<br>
<br>
<br>

**Satoshi Nakamoto -**

> ***“We shouldn’t delay forever until every possible feature is done. There’s always going to be one more thing to do.”***

<br>
<br>
<br>
<br>
<br>
<hr>
<br>
<br>
<br>
<br>
