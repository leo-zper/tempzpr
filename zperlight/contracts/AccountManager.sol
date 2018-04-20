pragma solidity ^0.4.21;

contract AccountManager {

	enum AccountType { NotAvailable, Borrower, Lender, NPLBuyer, Guardian, P2PL, RoboAdvisor }
	//	for internal use				1			2		3		4		5		6
	//

  	struct AccountInfo {
		uint256	value;
		string	coin;				// coin type
		string	alias;				// nickname
		AccountType	accountType;	// Borrower, Lender, NPL Buyer, Guardian
									// P2PL, RoboAdvisor
		string option;
	}

	address owner;

	uint8 public totalAccounts;
	uint8 public councils;
	uint8 public publishers;

	// manage seprately with accounts. council can be P2PL or Roboadvisor also.
	mapping (address => bool) internal council;
	mapping (address => AccountInfo) internal publisher;

	// accounts[sale address][participants address] : AccountInfo
	mapping (address => mapping (address => AccountInfo)) internal accounts;


	function AccountManager(address _owner) public {
		require(_owner != address(0));
		owner = _owner;
		council[owner] = true;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	// check if the msg.sender is registered as a publisher in the sale 

	modifier onlyCouncil() {
		require(council[msg.sender] == true);
		_;
	}

	function transferOwnership(address _newOwner) onlyOwner external {
		require(_newOwner != address(0));
		owner = _newOwner;
	}

	function assignCouncil(address _council) onlyOwner external {
		require(_council != address(0));
		council[_council] = true;
		councils++;
	}

	function fireCouncil(address _council) onlyOwner external {
		require(council[_council] == true);
		council[_council] = false;
		councils--;
	}

	function isCouncil(address _who) public view returns (bool) {
		return council[_who];
	}
	function isPublisher(address _who) public view returns (bool) {
		if(publisher[_who].accountType == AccountType.P2PL  ||
		   publisher[_who].accountType == AccountType.RoboAdvisor)
			return true;
		return false;
	}
	
	function isLender(address _sale, address _who) external view returns (bool) {
		if(accounts[_sale][_who].accountType == AccountType.Lender)
			return true;
		return false;
	}

	function isBorrower(address _sale, address _who) external view returns (bool) {
		if(accounts[_sale][_who].accountType == AccountType.Borrower)
			return true;
		return false;
	}

	function isNPLBuyer(address _sale, address _who) external view returns (bool) {
		if(accounts[_sale][_who].accountType == AccountType.NPLBuyer)
			return true;
		return false;
	}
	function isGuardian(address _sale, address _who) external view returns (bool) {
		if(accounts[_sale][_who].accountType == AccountType.Guardian)
			return true;
		return false;
	}

	// function can register accounts information
	function registerAccounts(address _sale, address _acnt, uint _type, uint256 _value, string _coin, string _option) public returns (bool) {

		AccountInfo memory acnt;

		assembly {
			switch _type
			case 1 {
			}
			case 2 {
			}
		}
		
		if(_type == 1) {
			acnt.accountType = AccountType.Borrower;
		}
		else if(_type == 2) {
			acnt.accountType = AccountType.Lender;
		}
		else if(_type == 3) {
			acnt.accountType = AccountType.NPLBuyer;
		}
		else if(_type == 4) {
			acnt.accountType = AccountType.Guardian;
		}
		else if(_type == 5) {
			if(!isCouncil(msg.sender))
				return false;
			acnt.accountType = AccountType.P2PL;
			publisher[_acnt] = acnt;
			publishers++;
		}
		else if(_type == 6) {
			if(!isCouncil(msg.sender))
				return false;
			acnt.accountType = AccountType.Guardian;
			publisher[_acnt] = acnt;
			publishers++;
		}

		acnt.value = _value;
		acnt.coin = _coin;
		acnt.option = _option;

		acnt.accountType = AccountType(_type);

		accounts[_sale][_acnt] = acnt;
		totalAccounts++;
		return true;
	}

	// delete all kinds of accounts except council
	function deleteAccounts(address _sale, address _delete) onlyCouncil external {
		AccountInfo memory dummy;

		dummy.accountType = AccountType.NotAvailable;
		accounts[_sale][_delete] = dummy;
		if(isPublisher(_delete)) {
			publisher[_delete] = dummy;
			publishers--;
		}
		totalAccounts--;
	}

}
