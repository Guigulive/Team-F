/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    
    uint private constant payDuration = 10 seconds;
    
    address private owner;
    uint private salary = 1 ether;
    address private employee;
    uint private lastPayday = now;
    
    function Payroll() public {
        owner = msg.sender;
    }
    
    function updateEmployeeAddressAndSalary(address a, uint s) public{
        require(msg.sender == owner);
        assert(s > 0);
        
        // 结余上一个员工
        if (a != 0x0) {
            employee.transfer((now-lastPayday)*salary/payDuration);
        }
        
        employee = a;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable public returns (uint)  {
        return this.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        require(msg.sender == owner);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
}
