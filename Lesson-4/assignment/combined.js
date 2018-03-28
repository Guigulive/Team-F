var Payroll = artifacts.require("Payroll");

contract('Payroll', function(accounts) {
	var payroll;

	before(() => {
		return Payroll.new().then( function (instance){
			payroll = instance;
		});
    });
    
    

	it('can add two employees and remove them when the balance is enough', function () {
        var e3 = accounts[2];
        var e4 = accounts[3];

		payroll.addEmployee(e3, 1, {
			from: accounts[0]
		}).then( function() {
			return payroll.employees.call(e3);
		}).then( function(result){
			assert.equal(result[0], e3, "should be accounts[1]");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		}).then( function () {
			
			payroll.addEmployee(e4, 1, {
				from: accounts[0]
			});
		}).then( function() {
			return payroll.employees.call(e4);
		}).then( function(result){
			assert.equal(result[0], e4, "should be accounts[2]");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		}).then( function () {

			payroll.addFund({from: accounts[0], value: web3.toWei('10', 'ether')});
		}).then(function() {
		  return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
		}).then(function(){
		  return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
		}).then(function() {
			return payroll.removeEmployee(e3, {from: accounts[0]});
		}).then( function (ret) {
			return payroll.employees.call(e3, {
				from: accounts[0]
			});
		}).then( function(result){
			assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[1] should not be an employee");

		}).then(function() {
			return payroll.removeEmployee(e4, {from: accounts[0]});
		}).then( function (ret) {
			return payroll.employees.call(e4, {
				from: accounts[0]
			});
		}).then( function(result){
			assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[2] should not be an employee");
		});
    });
});