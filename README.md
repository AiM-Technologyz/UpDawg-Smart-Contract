# UpDawg Smart Contract

“If you don't believe me or don't get it, I don't have time to try to convince you, sorry.”

- Satoshi Nakamoto

## What is UpDawg?
UpDawg is a TRC20 smart contract on the TRON blockchain. The smart contract consists of a token(UDAWG) with an in-built DEX(dawgDEX). UDAWG is a Proof Of Reserve token backed by TRX. UDAWG can be purchased & sold on the dawgDEX.

## Technology
Once deployed on the blockchain, the Launchpad will be in effect and initially the TRX Reserve will have 0.000001 TRX sent by DawgDAO in exchange for 21 UDAWG tokens to set the price of UDAWG tokens as : 21 Million UDAWG = 1 TRX.

## Launchpad
Once deployed on the blockchain, the Launchpad will be in effect and initially the TRX Reserve will have 1 TRX sent by DawgDAO in exchange for 21 million UDAWG tokens to set the price of UDAWG tokens as : 21 Million UDAWG = 1 TRX.

## Price Formula
The price formula of UDAWG token is - UDAWG Total Supply dvided by Total TRX in UpDawg Reserve.

## dawgDEX
The conclusion of Launchpad marks the inception of the dawgDEX. The exchange fee will be set at 1% for purchasing tokens and 10% for selling tokens. The exchange fee will automatically change based on the TRX reserve of the UpDawg contract, according to the below Fee Schedule.

## Fee schedule
TRX Reserve Target	Deposit Fee (%)	Withdraw Fee (%)
0 <= Reserve < 1	1	10
1 <= Reserve < 10	0.9	9
10 <= Reserve < 100	0.8	8
100 <= Reserve < 1k	0.7	7
1k <= Reserve < 10k	0.6	6
10k <= Reserve < 100k	0.5	5
100k <= Reserve < 1M	0.4	4
1M <= Reserve < 10M	0.3	3
10M <= Reserve < 100M	0.2	2
100M <= Reserve < 1B	0.1	1
Reserve >= 1B	0.09	0.9
Transaction Fee Distribution

## Functions
The UpDawg smart contract implements the standard TRC20 functions along with the following additional functions :


### Buy : 
this action will transfer user specified TRX to the UpDAWG smart contract address , and mint UDAWG on the user address depending on the current price stated on dawgDEX


### Sell : 
this action will Burn user specified UDAWG , and transfer TRX to the user address depending on the current price stated on dawgDEX. At any given time, only 90% of UDAWG can be sold on dawgDEX.


### Burn : 
this operation can burn any number of UDAWG tokens.


### Claim Reward : 
this event will allow HODLers to claim their share from HODLersPool and mint 0.01% new tokens of their reward.


### Transfer : 
transferring UDAWG will also execute the ‘Claim Reward’ function for both the sender & receiver.


Donate Reward : this action allows anyone to send UDAWG to HODLersPool.


Claim Airdrop : this function will be functional only during the Launchpad. It will allow users to mint 1 million UDAWG tokens per claim.


Every function will be executed by using the TronLink interface directly from the DEX website, protected by TLS. TRON blockchain native token (TRX) will be used for implementing UpDAWG operations. Generally fee will be less than 40 TRX and can be laid down to 0 TRX if the user has sufficient Energy & bandwidth available.


Transparency
The UpDAWG smart contract manages the UDAWG token & the TRX reserve, ensuring a decentralised & trustless process. Contract owner can not interfere with the smart contract’s specifications except for 2 predetermined functions(updateBuyFee &updateSellFee), hard coded in the smart contract code, as the code is open source.
There is no method in the UpDAWG smart contract to withdraw the TRX Reserve or UDAWG HODLpool. The internal reserves in the smart contract is viewable to make sure token value is backed by the expected amount of collateral. To look into the reserve users can visit UpDAWG website or TRON blockchain explorer, as UpDAWG is an TRC20 smart contract all the reserves are on-chain.
To ensure no chance of scam or security risk, the UpDAWG smart contract will be audited.

“We shouldn’t delay forever until every possible feature is done. There’s always going to be one more thing to do.”

- Satoshi Nakamoto