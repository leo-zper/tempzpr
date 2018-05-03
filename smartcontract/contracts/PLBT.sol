pragma solidity ^0.4.21;

import "./library/SafeMath.sol";

contract PLBT {

	using SafeMath for uint256;

	address public owner;
	uint256 public totalSupply;

	string public constant name = "Zper PLBT";
	string public constant symbol = "PLBT";
	uint8 public constant decimals = 3;

	struct BondInfo {
		uint256		ID;
		uint256		startDate;
		uint256		endDate;
		uint		interest;
		string		docLink;
	}

	BondInfo bond;
	mapping (address => uint256) public balances;
	mapping (address => mapping (address => uint256)) public allowed;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


	function PLBT (address _owner, uint _totalSupply) public {
		require(_owner != address(0));
		require(_totalSupply > 0);

		totalSupply = _totalSupply * (10 ** 3);
		owner = _owner;
		balances[owner] = totalSupply;
	}

	modifier onlyOwner () {
		require(msg.sender == owner);
		_;
	}

	function getDocLInk() external view returns (string) {
		return bond.docLink;
	}

	function transferOwnership(address newOwner) onlyOwner public {
		require(newOwner != address(0));
		owner = newOwner;
		emit OwnershipTransferred(owner, newOwner);
	}

	function transfer(address _to, uint256 _value) public returns (bool) {
		require(_to != address(0));
		require(balances[msg.sender] >= _value);
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
		balances[_to] = balances[_to].add(_value);
		balances[_from] = balances[_from].sub(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		emit Transfer(_from, _to, _value);
		return true;
	}

	function balanceOf(address _owner) public constant returns (uint256) {
		return balances[_owner];
	}

	function approve(address _spender, uint256 _value) public returns (bool) {
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) public constant returns (uint256) {
		return allowed[_owner][_spender];
	}


}
