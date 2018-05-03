This document and codes in this repository are not finalized yet.  We're still working on the rules, policies and mechanisms.

# Zper Service Prototype (ZperLight)
zperLight is a lending service with ethereum based contracts. All participants in Zper eco system can use this service.
Publishers(P2PL, Robo Advisor) can deploy BondSale contract and PLBT contract. (All participants can obtain publisher autorization after proper assessment)


consists of 
- account manager
- Sale Template Contract for Zper Service
- PLBT Template Contract for Zper Service 

options
- multisig transaction

## How to use


## Account Manager
All accounts in Zper eco system is managed by this contract.
Accounts types are as follows.
- Council Member: control major decisions
- Lender		: invest zpr or eth to a bond
- P2PL			: publish bond sale
- RoboAdvisor	: publish bond sale
- NPL Buyer		: backup players
- Guardian		: backup players
- Borrower		: lend zpr or eth from bond sale

### Functions
register accounts in zper eco system
verify accounts in zper eco system
delete accounts

### Policies
Assigning and firing council members are decided by a vote from all council members.
Owner can run assigning and firing function. Ownership can be transferred.

Council member can register publishers.
Council member can delete any kinds of accounts.

All participants can register themselves as a Borrower, Lender, NPL Buyer or Guardian.

## Sale Template for Zper Service 
Publishers publish PLBT contract and BondSale contract. When PLBT is linked to Sale contract, the PLBT has its own value.

Sale contract have to be linked with Zper token, AccountManager contract and PLBT contract when it's deployed. Otherwise ot won't work properly.

### Basic Functions
ZPR, ETH transaction handling
exchange rate calculation
crypto currency forwarding
check fund raised by lenders
check fund raised by backup players

basic information getter

### Borrower IF
apply for loan
return loan

### Lender IF
invest
claim return

### Publisher IF
#### Sale managing
set rates and interest
change sale stages
auto registration(TBD)
desposit for publication

### BackUps IF
promise to buy NPL (with deposit?)
promise to assure guardian service (with deposit?)


## PLBT Template for Zper Service 
PLBT is a tokenized bond guaranteed by a publisher(P2PL, RoboAdvisor). All publishers are obliged to pay ZPR or ETH for PLBT connected to the sale contract.
All participants can trade PLBT freely.

complied with ERC20

