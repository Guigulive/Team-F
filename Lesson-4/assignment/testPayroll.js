var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', async (accounts) => {
  let payroll;
  let owner = accounts[0];
  let employeeId = accounts[1];

  beforeEach(async function () {
    payroll = await Payroll.new();
  });

  it("should add employee successfully", async () => {
    await payroll.addEmployee(employeeId,1);
    let res = await payroll.employees.call(employeeId);
    assert.equal(res[0], employeeId);
    assert.equal(res[1].toNumber(), web3.toWei(1,'ether'));
  });

  it("should remove employee successfully", async () => {
    await payroll.addFund({from: owner, value: web3.toWei(10, "ether")});
    await payroll.addEmployee(employeeId,1);
    await payroll.removeEmployee(employeeId);
    let res = await payroll.employees.call(employeeId);
    assert.equal(res[0], 0x0);
  });

  it("should getPaid correctly", async () => {
    await payroll.addFund({from: owner, value: web3.toWei(10, "ether")});
    await payroll.addEmployee(employeeId,1);
    let oldBalance = Math.round(web3.fromWei((await web3.eth.getBalance(employeeId)).toNumber(),'ether'));
    web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [11], id: 0});
    await payroll.getPaid({from: employeeId});
    let newBalance = Math.round(web3.fromWei((await web3.eth.getBalance(employeeId)).toNumber(),'ether'));
    assert.isAbove(newBalance, oldBalance);
  });
});
