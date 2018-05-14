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
register accounts in zper eco system<br />
verify accounts in zper eco system<br />
delete accounts<br />

### Policies
Assigning and firing council members are decided by a vote from all council members.<br />
Owner can run assigning and firing function. Ownership can be transferred.<br />

Council member can register publishers.<br />
Council member can delete any kinds of accounts.<br />

All participants can register themselves as a Borrower, Lender, NPL Buyer or Guardian.

## Sale Template for Zper Service 
Publishers publish PLBT contract and BondSale contract. When PLBT is linked to Sale contract, the PLBT has its own value.

Sale contract have to be linked with Zper token, AccountManager contract and PLBT contract when it's deployed. Otherwise ot won't work properly.

### Key Transactions
- apply for a loan: borrowers to publishers
- accept or reject: publishers to borrowers
- return of a loan: borrowers to publishers
- invest: lenders to publishers
- claim investment: lenders to publishers
- publish crowd sale: publishers
- close crowd sale: publishers
- buy NPL: backups to publishers

### Functions
ZPR, ETH transaction handling,
exchange rate calculation,
crypto currency forwarding,
check fund raised by lenders,
check fund raised by backup players,

basic information getter

### Borrower IF
apply<br />
return<br />

### Lender IF
invest<br />
claim<br />

### Publisher IF
#### Sale managing
set rates and interest<br />
change sale stages<br />
auto registration(TBD)<br />
desposit for publication<br />

### BackUps IF
promise to buy NPL (with deposit?)<br />
promise to assure guardian service (with deposit?)<br />


## PLBT Template for Zper Service 
PLBT is a tokenized bond guaranteed by a publisher(P2PL, RoboAdvisor). All publishers are obliged to pay ZPR or ETH for PLBT connected to the sale contract.
All participants can trade PLBT freely.

complied with ERC20

