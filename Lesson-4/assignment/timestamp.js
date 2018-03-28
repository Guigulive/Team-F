var Payroll = artifacts.require("Payroll");

contract('Payroll', function(accounts) {
	var payroll;

	before(() => {
		return Payroll.new().then( function (instance){
			payroll = instance;
		});
    });
    
    // add timestamp
	// Notes: timestamps testing is not independent
	// Right now, set payDuration = 10 seconds
	it('can add one employee and remove it when the balance is enough', function () {
        var e1 = accounts[1];
		payroll.addEmployee(e1, 1, {
			from: accounts[0]
		}).then( function() {
			return payroll.employees.call(e1);
		}).then( function(result){
			assert.equal(result[0], e1, "should be accounts[1]");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		}).then( function () {
			return payroll.addFund({from: e1, value: web3.toWei('2', 'ether')});
		}).then(function() {
		  return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
		}).then(function(){
		  return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
		}).then(function() {
			return payroll.removeEmployee(e1, {from: accounts[0]});
		}).then( function () {
			return payroll.employees.call(e1, {
				from: accounts[0]
			});
		}).then( function(result){
			assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[1] should not be an employee");
		});
	});


	it('can add employee but cannot remove it when the balance is not enough', function () {
        var e2 = accounts[2];
		payroll.addEmployee(e2, 1, {
			from: accounts[0]
		}).then( function() {
			return payroll.employees.call(e2);
		}).then( function(result){
			assert.equal(result[0], e2, "should be accounts[2]");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		}).then( function () {
			return payroll.addFund({from: e2, value: web3.toWei('1', 'ether')});
		}).then(function() {
		  	return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [21], id: 0});
		}).then(function(){
		  	return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
		}).then(function() {
			return payroll.removeEmployee(e2, {from: accounts[0]});
		}).then( function(ret) {
			assert(false, "partial pay unsuccessful");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});

	
});