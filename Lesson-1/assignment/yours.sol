/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {

    address private thisAddress = this;
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
        require(s > 0);
        
        // 结余上一个员工
        if (employee != 0x0) {
            employee.transfer((now-lastPayday)*salary/payDuration);
        }
        
        employee = a;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable public returns (uint)  {
        return thisAddress.balance;
    }
    
    function calculateRunway() public returns (uint) {
        return thisAddress.balance / salary;
    }
    
    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
}
