pragma solidity^0.4.21;

contract MultiSig {

	uint8 public	totalCosigner;
	uint8 private	votedFor;
	uint8 private	minimum;
	address private holder;


	mapping (address => bool) internal cosigners;
	mapping (uint8 => address) internal cosignersArr;		// for reset cosigners info

	event SignRequest(address holder, address[] _cosigner, uint8 _minimum);

	modifier approved() {
		require(votedFor > minimum);
		_;
	}

	modifier onlyCosigner() {
		require(cosigners[msg.sender]);
		_;
	}

	function request(address[] _cosigner, uint8 _minimum) public returns(bool) {
		require(votedFor == 0);
		require(_cosigner.length >= _minimum && _cosigner.length < 255);

		for(uint8 i = 0; i < _cosigner.length; i++)  {
			cosigners[_cosigner[i]] = true;
			cosignersArr[i] = _cosigner[i];
		}

		totalCosigner = uint8(_cosigner.length);
		minimum = _minimum;
		holder = msg.sender;
		votedFor = 1;
		cosigner[msg.sender] = false;
		emit SignRequest(msg.sender, _cosigner, _minimum);
	}

	function voteFor() onlyCosigner public returns(bool) {
		votedFor++;
		cosigner[msg.sender] = false;
	}

	// must be included in transaction function's end
	function txFinished() public {
		require(msg.sender == holder);

		for(uint8 i = 0; i < totalCosigner; i++)
			cosigners[cosignersArr[i]] = false;

		totalCosigner = 0;
		votedFor = 0;
		minimum = 255;
	}

	function getVotes() public view returns(uint8) {
		return votedFor;
	}
}
