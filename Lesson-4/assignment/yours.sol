var Payroll = artifacts.require("./Payroll.sol");

  it("should add Employee correctly.", function(){
    var address;
    var salary;

    return Payroll.deployed().then(function(ins) {
      payrollInstance = ins;
      return payrollInstance.addEmployee(web3.eth.accounts[1],1);
    }).then(function(){
      return payrollInstance.employees.call(web3.eth.accounts[1]);
    }).then(function(res){
      address = res[0];
      salary = res[1].toNumber();

      assert.equal(address, web3.eth.accounts[1]);
      assert.equal(salary, web3.toWei(1,'ether'));
    });
  });

  it("should remove Employee correctly.",function(){
    var removeAddress;
    var removeSalary;

    return Payroll.deployed().then(function(ins) {
      payrollInstance = ins;
      return payrollInstance.addEmployee(web3.eth.accounts[1],1);
    }).then(function(){
      return payrollInstance.removeEmployee(web3.eth.accounts[1]);
    }).then(function(){
      return payrollInstance.employees.call(web3.eth.accounts[1]);
    }).then(function(res){
      removeAddress = res[0];
      removeSalary = res[1].toNumber();

      assert.equal(removeAddress, 0x0);
      assert.equal(removeSalary, 0);
    });
  });

