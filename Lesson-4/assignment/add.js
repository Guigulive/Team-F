var Payroll = artifacts.require("Payroll");

contract('Payroll', function(accounts) {
	var payroll;

	before(() => {
		return Payroll.new().then( function (instance){
			payroll = instance;
		});
	});

	it('owner is accounts[0]', function () {
		return payroll.owner().then( function (result){
			assert.equal(result, accounts[0]);
		});
	});
	
	it('can add one employee', function () {
		var e1 = accounts[1];
		
		payroll.addEmployee(e1, 1, {
			from: accounts[0]
		}).then( function() {
			return payroll.employees.call(e1);
		}).then( function(result){
			assert.equal(result[0], e1, "should be e1");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		});
	});

	it('cannot add employee from non-owner', function () {
		var e1 = accounts[2];
		var nonOwner = accounts[3];

		return payroll.addEmployee(e1, 1, {
			from: nonOwner
		}).then( function(ret) {
			assert(false, "non-owner can't add employee");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});

	it('cannot add an existing employee from non-owner', function () {
		var e1 = accounts[4];
		payroll.addEmployee(e1, 10, {
			from: accounts[0]
		}).then( function() {
			return payroll.addEmployee(e1, 10, {
				from: accounts[0]
			});
		}).then( function(ret) {
			assert(false, "non-owner can't add employee");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});

	it('cannot add an employee from an employee', function () {
		payroll.addEmployee(accounts[5], 10, {
			from: accounts[0]
		}).then( function() {
			return payroll.addEmployee(accounts[6], 10, {
				from: accounts[7]
			});
		}).then( function(ret) {
			assert(false, "employee can't add employee");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});

	it('can add two employees', function () {
		var e1 = accounts[8];
		var e2 = accounts[9];

		payroll.addEmployee(e1, 1, {
			from: accounts[0]
		}).then( function() {
			return payroll.employees.call(e1);
		}).then( function(result){
			assert.equal(result[0], e1, "should be e1");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		}).then( function () {
			
			payroll.addEmployee(e2, 1, {
				from: accounts[0]
			});
		}).then( function() {
			return payroll.employees.call(e2);
		}).then( function(result){
			assert.equal(result[0], e2, "should be e2");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		});
	});
});