pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";


contract TestPayroll  is Payroll{
  

  function testAddEmployee(address addr,uint sal) public {

        addEmplyee(addr,sal);

    Assert.equal(employeeMapping[addr].salary, sal, "添加失败");
  }

  function testRemoveEmployee(address addr) public {
     removeEmployee(addr);
     Assert.equal(employeeMapping[addr].salary, 0, "删除失败");
  }

}
