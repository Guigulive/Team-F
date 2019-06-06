/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    
    uint constant payDuration  = 2 seconds;
    address owner;
    uint salary;
    address employee;
    uint lastPayday;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function updateEmployee(address e,uint s){
        
        if (employee != 0x0)
        {
            uint payment = salary * (now - lastPayday)/payDuration;
            employee.transfer(payment);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint)
    {
        return this.balance/salary;
    }
    
    function hasEnoughFund() returns(bool)
    {
        return calculateRunway()>0;
    }
    
    function getPaid()
    {
        if(msg.sender != employee)
        {
            revert();
        }
        
        uint nextPayday = lastPayday+payDuration;
        if(nextPayday>now){
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
