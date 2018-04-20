var PLBT = artifacts.require("./PLBT.sol");
var BondSale = artifacts.require("./BondSale.sol");
var AccountManager = artifacts.require("./AccountManager.sol");
var ZperToken = artifacts.require("./ZperToken.sol");


module.exports = function(deployer) {
	// ethereum live network
	// const zprAddress = "0x7C539BDEB5e20B084aF0722158A1b5613B328c7A";
	
	// rinkeby
	// const zprAddress = "0xe8629c451f9019df9dc6e0e7dafda038232fdf38";
	
	deployer.deploy(AccountManager, web3.eth.accounts[0]);
	deployer.deploy(ZperToken, web3.eth.accounts[0], 1000000, 2000000);
	deployer.deploy(PLBT, web3.eth.accounts[0], 1000000);
	deployer.deploy(BondSale, web3.eth.accounts[0], AccountManager.address, 
			ZperToken.address, PLBT.address);

};
