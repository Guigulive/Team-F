pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

//
contract TestPayroll is Payroll {
  address addr = 0x003abc49256c578e6c0196932054998e0e851879;
//2.使用继承能够覆盖所有测试路径和捕捉异常
  function testAddEmployee() public {

    addEmplyee(addr,1);

    Assert.equal(employeeExisted(addr), true, "添加失败");
  }

  function testRemoveEmployee() public {
     removeEmployee(addr);
     Assert.equal(employeeExisted(addr), false, "删除失败");
  }

}
