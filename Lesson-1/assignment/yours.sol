/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether; //工资
    address employee; //员工地址
    address owner; //老板地址
    uint lastPayday ; // 上次发薪水的时间
    
    uint constant payDuration = 10 seconds;// 发薪水的时间间隔
    
    //设置老板地址
    function Payroll() public {
        owner = msg.sender;
    }
    

    function updateEmployeeAddressSalary(address e, uint s){
        require(msg.sender == owner);
        require(s>0);
        
        //修改前先结余
        if(e != 0x0 ){
            uint shouldPay = salary*(now-lastPayday)/payDuration;
            employee.transfer(shouldPay);
        }
        
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
        
    }
    
    
    
    
    //给智能合约打钱
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //计算智能合约的钱能支付薪水多少次
    function calculateRunway() returns (uint) {
        return this.balance/salary;
    }
    
    //智能合约的钱是否足够支付薪水
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    //获得薪水
    function getPaid() {
        require(msg.sender == employee);
        
       uint nextPayday = lastPayday + payDuration;
        
       assert(nextPayday<now);
       
       lastPayday = nextPayday;
       
       employee.transfer(salary);
        
    }
}
