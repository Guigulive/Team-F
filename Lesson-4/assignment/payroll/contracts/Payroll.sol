/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import "./Ownable.sol";
import "./SafeMath.sol";


contract Payroll is Ownable {
     using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    
    uint constant payDuration = 10 seconds;

    mapping(address=>Employee) public employees;
    
    uint totalSalary =0;

    modifier employeeExists(address employeeId) {
      var employee = employees[employeeId];
      assert(employee.id != 0x0);
       _;
    }
    
    modifier employeeNotExists(address employeeId) {
      var employee = employees[employeeId];
      assert(employee.id == 0x0);
       _;
    }    
    
    function _partialPaid(Employee employee) private {
        uint payment =  employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExists(employeeId)  {
        totalSalary = totalSalary.add(salary.mul(1 ether));
        employees[employeeId]=Employee(employeeId, salary.mul(1 ether), now);
    }
 
    function removeEmployee(address employeeId) onlyOwner  employeeExists(employeeId)  {
        var employee = employees[employeeId];
        totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee);
        delete employees[employeeId];
    }
   
    
    function updateEmployee(address employeeId, uint salary) onlyOwner  employeeExists(employeeId)  {
        var employee = employees[employeeId];
         totalSalary = totalSalary.sub(employee.salary);
        _partialPaid(employee);
         totalSalary = totalSalary.add(salary.mul(1 ether));
        employee.lastPayday = now;
        employee.salary = salary.mul(1 ether);
    }
    
    function changePayAddress(address employeeId) employeeExists(msg.sender) employeeNotExists(employeeId) {
        var employee = employees[msg.sender];
        employees[employeeId]=Employee(employeeId, employee.salary.mul(1 ether), employee.lastPayday);
        delete employees[msg.sender];
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() returns (bool) {
         return calculateRunway()>0;
    }
    
    function getPaid() employeeExists(msg.sender) {
       var employee = employees[msg.sender];
       uint nextPayday = employee.lastPayday.add(payDuration);
       require(nextPayday<now);
       employee.lastPayday = nextPayday;
       employee.id.transfer(employee.salary);
    }
}

