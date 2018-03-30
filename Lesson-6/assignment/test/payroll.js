var Payroll = artifacts.require("./Payroll.sol");
var salary = 3;

contract('Payroll', function(accounts) {

  var account = accounts[1];

  it("Payroll合约测试addEmployee和removeEmployee函数", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("添加账号：",account);
      return PayrollInstance.addEmployee(account,salary,{from: accounts[0]});
    }).then(function() {
      console.log("操作结果：成功!!");
      console.log("检测地址 employees['"+account+"']");
      return PayrollInstance.employees.call(account);
    }).then(function(storedData) {
      console.log("＝＝＝＝检测结果＝＝＝＝");
      console.log("账户地址：",storedData[0]);
      console.log("账户工资：",storedData[1].toNumber());
      console.log("上次支付时间：",storedData[2].toNumber());
      console.log("删除账号：",account);
      return PayrollInstance.removeEmployee(account,{from: accounts[0]});
      // assert.equal(storedData[1].toNumber(), web3.toWei(salary,'ether'), "failure");
    }).then(function(storedData) {
      console.log("地址删除地功");
      console.log("检测地址 employees['"+account+"']");
      return PayrollInstance.employees.call(account); 
    }).then(function(storedData) {
      console.log("＝＝＝＝检测结果＝＝＝＝");
      console.log("账户地址：",storedData[0]);
      console.log("账户工资：",storedData[1].toNumber());
      console.log("上次支付时间：",storedData[2].toNumber());
      var address = web3.toBigNumber(storedData[0]).toNumber();
      assert.equal(address, 0, "测试失败！");   
    });
  });

});
