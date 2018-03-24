/*作业请提交在这个目录下*/
var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
  let instance;
  let owner = accounts[0];
  let employeeId = accounts[1];
  let payDuration = 4000; //should be same as defined in Payroll.sol
  let initialDeposit = 10;
  function timeout(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  function getBalance(address) {
    return web3.eth.getBalance(address).toNumber();
  }

  beforeEach(async () => {
    instance = await Payroll.new({from: owner});
  })


  describe("test addEmployee", () => {
    it("should be onlyOwner", async () => {
      try {
        await instance.addEmployee(employeeId, 1, {from: employeeId});
      } catch (e) {
        // 如果其他账号操作，应该进入catch分支
        assert.notEqual(employeeId, owner, `${employeeId} is not owner`);
      }
    });

    it("should set correct address and salary", async () => {
      await instance.addEmployee(employeeId, 1, {from: owner});
      const employee = await instance.employees(employeeId);
      assert.equal(employee[0], employeeId, "address.");
      assert.equal(web3.fromWei(employee[1].toNumber(), "ether"), 1, "salary.");
    });

    it("should get correct runaway", async () => {
      
      await instance.addFund({from: owner, value: web3.toWei(initialDeposit, "ether")});
      await instance.addEmployee(employeeId, 2, {from: owner});
      const runaway = await instance.calculateRunway();
      assert.equal(runaway.toNumber(), 5, "runaway.");
    });
    
  });
  
  describe("test removeEmployee", () => {
    it("should be onlyOwner", async () => {
      await instance.addEmployee(employeeId, 1, {from: owner});
      try {
        await instance.removeEmployee(employeeId, {from: employeeId});
      } catch (e) {
        // 如果其他账号操作，应该进入catch分支
        assert.notEqual(employeeId, owner, `${employeeId} is not owner`);
      }
    });

    it("should remove employee", async () => {
      
      await instance.addEmployee(employeeId, 1, {from: owner});
      let employee = await instance.employees(employeeId);
      assert.equal(employee[0], employeeId, "address.");

      await instance.removeEmployee(employeeId, {from: owner});
      employee = await instance.employees(employeeId);
      assert.equal(employee[0], 0, "address.");
    });

    it("should be partial paid", async () => {
      const waitTime = 1000;
      await instance.addFund({from: owner, value: web3.toWei(initialDeposit, "ether")});
      await instance.addEmployee(employeeId, 1, {from: owner});
      const beforeBalance = getBalance(employeeId);
      await timeout(waitTime);  
      await instance.removeEmployee(employeeId, {from: owner});
      const afterBalance = getBalance(employeeId);
      // console.log(afterBalance);
      // console.log(beforeBalance);
      // console.log((afterBalance-beforeBalance)/1e18);
      assert.equal((afterBalance-beforeBalance)/1e18, 1*waitTime/payDuration)
    })

  });

  describe("test getPaid", () => {

    it("should be employeeExist", async () => {
      await instance.addFund({from: owner, value: web3.toWei(initialDeposit, "ether")});
      try {
        await instance.getPaid({from: employeeId});
      } catch (e) {
        // 如果其为空，应该进入catch分支
        let employee = await instance.employees(employeeId);
        assert.equal(employee[0], 0, `${employeeId} dose not exist`);
      }
    });

    it("should getPaid", async () => {
      await instance.addFund({from: owner, value: web3.toWei(initialDeposit, "ether")});
      await instance.addEmployee(employeeId, 1, {from: owner});
      const oldBalance = getBalance(employeeId);
      
      await timeout(6000);

      await instance.getPaid({from: employeeId});
      const newBalance = getBalance(employeeId);
      assert.equal(Math.round(web3.fromWei(newBalance-oldBalance, "ether")), 1);
    });

    it("should update lastPayday", async () => {

      await instance.addFund({from: owner, value: web3.toWei(initialDeposit, "ether")});
      await instance.addEmployee(employeeId, 1, {from: owner});
      let employee = await instance.employees(employeeId);
      const previousPayTimestamp = employee[2].toNumber();
    
      await timeout(6000);
      
      await instance.getPaid({from: employeeId});
      employee = await instance.employees(employeeId);
      const newPayTimestamp = employee[2].toNumber();
      assert.equal(previousPayTimestamp+payDuration/1000, newPayTimestamp);
    });
  });
    
});
