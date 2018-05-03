pragma solidity ^0.4.21;

import "./ZperToken.sol";
import "./PLBT.sol";
import "./AccountManager.sol";
import "./library/SafeMath.sol";

contract BondSale {

	using SafeMath for uint256;

	address	public	owner;
	PLBT			plbt;
	AccountManager	acmgr;
	ZperToken 		zpr;

	uint256 public PLBTRate;		// ZPR to PLBT
	uint256 public ETHRate;			// ZPR to ETH

	uint256 public interest;

	uint256 public cap;
	mapping (address => uint256) loaned;
	uint256 public funded;
	uint256 public paidBack;
	uint256 public guardianFunded;
	uint256 public NPLBuyerPromised;

	enum SaleStage { NotAvailable, SaleCooking, OnSale, OffSale, PayingBack, Expired }
	// NotAvailable	: Default. before the Sale begin
	// SaleCooking	: Publisher is making the Sale Portfolio
	// OnSale		: Bond Sale is published and gathering Investors
	// OffSale		: Sale is ended. Investors are waiting for their returns
	// PayingBack	: Investors can claim their invests with interest
	// Expired		: Loan expired. NPL Buyers can buy PLBT connected to the sale

	SaleStage public saleStage;

	function BondSale (address _owner, address _acmgr, address _zpr, address _plbt) public {
		acmgr = AccountManager(_acmgr);

		require(acmgr.isPublisher(_owner));

		owner = _owner;
		plbt = PLBT(_plbt);
		zpr = ZperToken(_zpr);
		saleStage = SaleStage.SaleCooking;
	}

	function advanceStage(SaleStage _stage) onlyPublisher public returns (bool) {
		require(uint(saleStage) == uint(_stage) - 1);
		saleStage = SaleStage(_stage);
	}

	// transaction with ETH
	function () external payable {
		onCookingTransactions(msg.sender, msg.value, 2);	// type ETH
		onSaleTransactions(msg.sender, msg.value, 2, "");
		offSaleTransactions(msg.sender, msg.value, 2);
		payingBackTransactions(msg.sender, msg.value, 2);
	}
	// transactin with ZPR Token and PLBT
	function tokenFallback(address _from, uint256 _value, bytes _data) external payable {
		// use _data as a guardian service request
		onCookingTransactions(_from, _value, 1);
		onSaleTransactions(_from, _value, 1, _data);
		offSaleTransactions(_from, _value, 1);
		payingBackTransactions(_from, _value, 1);

	}

	//function autoRegistrationOnTransaction() 
	function applyForLoan(uint256 _value, uint8 _type) external returns (bool) {
		require(acmgr.isBorrower(this, msg.sender));
		if(_type == 1) {
			cap += _value;
			loaned[msg.sender] = _value;
		}
		else if(_type == 2) {
			cap += _value / ETHRate;
			loaned[msg.sender] = _value / ETHRate;
		}

	}

	// types  1:ZPR, 2:ETH
	function onCookingTransactions(address _from, uint256 _value, uint8 _type) internal returns (bool) {
		if(saleStage != SaleStage.SaleCooking)
			return false;

		if(acmgr.isGuardian(this, _from)) {	// 
			if(_type == 2)		// only by ZPR
				return false;
			guardianFunded += _value;
		}
		else if(acmgr.isNPLBuyer(this, _from)) {	// 
			if(_type == 2)		// only by ZPR
				return false;
			NPLBuyerPromised += _value;
		}
	}

	// types  1:ZPR, 2:ETH
	function onSaleTransactions(address _from, uint256 _value, uint8 _type, bytes _option) internal returns (bool) {
		if(saleStage != SaleStage.OnSale)
			return false;
		if(_option[0] == 'g'){
			// guardian service
		}
			
		if(acmgr.isLender(this, _from)) {	// lender investing
			if(_type == 1) {
				plbt.transfer(_from, howmuch(1, _value, 1));
				funded += _value;
			}
			else if(_type == 2) {
				plbt.transfer(_from, howmuch(3, _value, 1));
				funded += _value / ETHRate;
			}
		}
		else if(acmgr.isGuardian(this, _from)) {
			if(_type == 2)		// only by ZPR
				return false;
			guardianFunded += _value;
		}
		else if(acmgr.isNPLBuyer(this, _from)) {
			if(_type == 2)		// only by ZPR
				return false;
			NPLBuyerPromised += _value;
		}
	}

	function offSaleTransactions(address _from, uint256 _value, uint8 _type) internal returns (bool) {
		if(saleStage != SaleStage.OffSale)
			return false;
		if(acmgr.isBorrower(this, _from)) {		// borrower returns 
			if(_type == 1)
				loaned[_from] -=_value;
			else
				loaned[_from] -=_value / ETHRate;
		}
	}

	function payingBackTransactions(address _from, uint256 _value, uint8 _type) internal returns (bool) {
		if(saleStage != SaleStage.PayingBack)
			return false;

		if(acmgr.isBorrower(this, _from)) {
			if(_type == 1)
				loaned[_from] -=_value;
			else
				loaned[_from] -=_value / ETHRate;
		}
		else if(acmgr.isLender(this, _from)) {
			if(_type == 1) {
				zpr.transfer(_from, howmuch(1, _value, 0));
				paidBack += _value;
			}
			else if(_type == 2) {
				_from.transfer(howmuch(3, _value, 0));
				paidBack += _value / ETHRate;
			}
		}

	}

	function setRates(uint256 _PLBT, uint256 _ETH, uint256 _interest) onlyPublisher public returns (bool) {
		require(_PLBT != 0 && _ETH != 0);
		PLBTRate = _PLBT;
		ETHRate = _ETH;
		interest = _interest;
		return true;
	}

	function howmuch(uint8 _towhat, uint256 _value, uint8 _interest) internal view returns(uint256) {
		uint256 value;
		if(_towhat == 1) {				// from ZPR to PLBT
			value = _value * PLBTRate;
		}
		else if(_towhat == 2) {			// from PLBT to ZPR
			value = _value / PLBTRate * (1 + _interest / 100) ;
		}
		else if (_towhat == 3) {		// from ETH	to PLBT
			value = _value * PLBTRate * ETHRate;
		}
		else if (_towhat == 4) {		// from PLBT to ETH
			value = _value / PLBTRate / ETHRate * (1 + _interest / 100);
		}

		return value;
	}

	modifier onlyPublisher() {
		require(acmgr.isPublisher(msg.sender));
		_;
	}

	// coin type
	// 1: ZPR
	// 2: ETH
	function forwardFunds(address _to, uint256 _value, uint8 _coin) onlyPublisher public returns(bool) {
		if(_coin == 1)
			zpr.transfer(_to, _value);
		else if(_coin == 2)
			_to.transfer(_value);
	}

	function getLoanLeft(address _addr) public view returns(uint256) {
		return loaned[_addr];
	}

}

