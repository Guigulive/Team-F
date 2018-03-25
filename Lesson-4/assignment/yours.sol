/*作业请提交在这个目录下*/
## 硅谷live以太坊智能合约 第四课作业

### 第四课：课后作业
- 将第三课完成的payroll.sol程序导入truffle工程：
搞定：
- 在test文件夹中，写出对如下两个函数的单元测试：
- function addEmployee(address employeeId, uint salary) onlyOwner
var SimpleStorage = artifacts.require("./SimpleStorage.sol");

contract('SimpleStorage', function(accounts) {

  it("...should store the value 89.", function() {
    return SimpleStorage.deployed().then(function(instance) {
      simpleStorageInstance = instance;

      return simpleStorageInstance.addEmployee(accounts[0],1000);
    }).then(function(){
      SimpleStorage.getTotalSalary 
    })(function(totalSalary) {
      assert.equal(totalSalary, 89, "The value 89 was not stored.");
    });
  });

});
- function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId)
var SimpleStorage = artifacts.require("./SimpleStorage.sol");

contract('SimpleStorage', function(accounts) {

  it("...should store the value 89.", function() {
    return SimpleStorage.deployed().then(function(instance) {
      simpleStorageInstance = instance;

      return simpleStorageInstance.addEmployee(accounts[0],1000);
    }).then(function(){
      SimpleStorage.getTotalSalary 
    })(function(totalSalary) {
      assert.equal(totalSalary, 89, "The value 89 was not stored.");
    });
  });

});
- 思考一下我们如何能覆盖所有的测试路径，包括函数异常的捕捉
- (加分题,选作）
- 写出对以下函数的基于solidity或javascript的单元测试 function getPaid() employeeExist(msg.sender)
- Hint：思考如何对timestamp进行修改，是否需要对所测试的合约进行修改来达到测试的目的？
