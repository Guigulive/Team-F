/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
 
    uint salary;

    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;

    function Payroll() {
        owner = msg.sender;
    }
    
    // 修改员工地址：
    function chgEmployeeAddr(address e) returns (address) {
        require(msg.sender == owner);
        employee = e;
        return employee;
    }
    
    // 修改员工薪酬:
    function chgEmployeeSalary(uint s) returns (uint) {
        require(msg.sender == owner);
        salary = s;
        return salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == owner);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }

}
