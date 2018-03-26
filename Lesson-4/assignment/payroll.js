var Payroll = artifacts.require("./Payroll.sol");
var salary = 1;

contract('Payroll', function(accounts) {

  var account = accounts[1];

  it("1、addFund添加金额", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("******* 1、addFund添加金额");
      console.log("向合约中添加Fund：20 ether");
      return PayrollInstance.addFund({from: accounts[0],value:web3.toWei('20', 'ether')});
    }).then(function() {
      console.log("操作成功，当前合约余额是:");
      var balance = web3.eth.getBalance(PayrollInstance.address);
      console.log(web3.fromWei(balance.toNumber(),'ether'),'ether');
    });
  });

  it("2、addEmployee添加员工地址", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("******* 2、addEmployee添加员工地址");
      console.log("添加账号：",account);
      return PayrollInstance.addEmployee(account,salary,{from: accounts[0]});
    }).then(function() {
      console.log("操作结果：成功!!");
      console.log("检测地址 employees['"+account+"']");
      return PayrollInstance.employees.call(account);
    }).then(function(storedData) {
      console.log("＝＝＝＝检测结果＝＝＝＝");
      console.log("账户地址：",storedData[0]);
      console.log("账户工资：",web3.fromWei(storedData[1].toNumber(), 'ether'),'ether');
      console.log("上次支付时间：",storedData[2].toNumber());
    });
  });

  it("3、getPaid()函数", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("******* 3、getPaid()函数");
      console.log("RPC系统时间已经过了15秒");
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [15], id: 0});
      console.log("领工资账号：",account);
      return PayrollInstance.getPaid({from: account});
    }).then(function() {
      console.log("操作结果：成功!!");
      console.log("检测员工信息 employees['"+account+"']");
      return PayrollInstance.employees.call(account);
    }).then(function(storedData) {
      console.log("＝＝＝＝检测结果＝＝＝＝");
      console.log("账户地址：",storedData[0]);
      console.log("账户工资：",web3.fromWei(storedData[1].toNumber(), 'ether'),'ether');
      console.log("上次支付时间：",storedData[2].toNumber());
    });
  });

  it("4、removeEmployee函数", function() {
    return Payroll.deployed().then(function(instance) {
      PayrollInstance = instance;
      console.log("******* 4、removeEmployee函数");
      console.log("删除账号：",account);
      return PayrollInstance.removeEmployee(account,{from: accounts[0]});
    }).then(function(storedData) {
      console.log("地址删除地功");
      console.log("检测地址 employees['"+account+"']");
      return PayrollInstance.employees.call(account); 
    }).then(function(storedData) {
      console.log("＝＝＝＝检测结果＝＝＝＝");
      console.log("账户地址：",storedData[0]);
      console.log("账户工资：",web3.fromWei(storedData[1].toNumber(), 'ether'),'ether');
      console.log("上次支付时间：",storedData[2].toNumber());
      var address = web3.toBigNumber(storedData[0]).toNumber();
      assert.equal(address, 0, "测试失败！");   
    });
  });

});
