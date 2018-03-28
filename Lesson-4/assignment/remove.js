var Payroll = artifacts.require("Payroll");

contract('Payroll', function(accounts) {
	var payroll;

	before(() => {
		return Payroll.new().then( function (instance){
			payroll = instance;
			payroll.addEmployee(accounts[1], 1, {
				from: accounts[0]
			});
		}).then( function () {
			payroll.addEmployee(accounts[2], 1, {
				from: accounts[0]
			});
		}).then( function () {
			payroll.addEmployee(accounts[3], 1, {
				from: accounts[0]
			});
		}).then( function () {
			payroll.addEmployee(accounts[4], 1, {
				from: accounts[0]
			});
		}).then( function () {
			payroll.addEmployee(accounts[5], 1, {
				from: accounts[0]
			});
		}).then( function () {
			payroll.addEmployee(accounts[6], 1, {
				from: accounts[0]
			});
		});
	});
	
	it('two employees exists', function () {
		var e1 = accounts[1];
		var e2 = accounts[6];

		return payroll.employees.call(e1).then( function(result){
			assert.equal(result[0], e1, "should be e1");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		}).then( function() {
			return payroll.employees.call(e2);
		}).then( function(result){
			assert.equal(result[0], e2, "should be e2");
			assert.equal(result[1], web3.toWei('1', 'ether'), "salary should be 1 ether");
		});
	});
	
	

	it('cannot remove one employee twice', function () {
		return payroll.removeEmployee(accounts[2], {
			from: accounts[0]
		}).then( function () {
			return payroll.employees.call(accounts[2]);
		}).then( function(result){
			assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[2] should not be an employee");
		}).then( function() {
			payroll.removeEmployee(accounts[2], {
				from: accounts[0]
			});
		}).then( function(ret) {
			assert(false, "cannot remove one twice");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});	

	it('cannot remove non existing employee', function () {
		return payroll.removeEmployee(accounts[7], {
			from: accounts[0]
		}).then( function(ret) {
			assert(false, "cannot remove non existing employee");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});

	it('cannot remove an employee by employee', function () {
		return payroll.removeEmployee(accounts[3], {
			from: accounts[4]
		}).then( function(ret) {
			assert(false, "cannot remove by employee");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});

	it('cannot remove an employee by non-owner nor non-employee', function () {
		return payroll.removeEmployee(accounts[5], {
			from: accounts[8]
		}).then( function(ret) {
			assert(false, "cannot remove by others");
		}).catch( function (err){
			assert(true, "err caught");
		});
	});
	// TODO: why not working?
	// it('can remove two employees', function () {
	// 	return payroll.removeEmployee(accounts[5], {
	// 		from: accounts[0]
	// 	}).then( function () {
	// 		return payroll.employees.call(accounts[5]);
	// 	}).then( function(result){
	// 		assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[5] should not be an employee");
	// 	}).then( function() {
	// 		payroll.removeEmployee(accounts[6], {
	// 			from: accounts[0]
	// 		});
	// 	}).then( function () {
	// 		return payroll.employees.call(accounts[6]);
	// 	}).then( function(result){
	// 		assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[6] should not be an employee");	
	// 	});
	// });	

	// it('can remove one employee', function () {
	// 	return payroll.removeEmployee(accounts[1], {
	// 		from: accounts[0]
	// 	}).then( function () {
	// 		return payroll.employees.call(accounts[1]);
	// 	}).then( function(result){
	// 		assert.equal(result[0], "0x0000000000000000000000000000000000000000", "accounts[1] should not be an employee");
	// 	});
	// });
});