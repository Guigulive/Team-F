pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    
    uint constant payDuration = 10 seconds;
    
    // Employee[] employees;
    // address owner;
    
    mapping (address => Employee) public employees;
    uint salarysum = 0;

    
    //初始化，设置owner,lastPayday
    //function Payroll() public{
    //    owner = msg.sender;
    //}
    
    //modifier onlyOwner {
    //    require(msg.sender == owner);
    //    _;
    //}
    
    //检查employeeId存在
    modifier employeeExist(address employeeId){
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    //检查employeeId不存在
    modifier employeeNonExist(address employeeId){
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    //检查是否到达结算周期
    modifier moreThanpayDuration(address employeeId){
        Employee storage employee = employees[employeeId];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        _;
    }

 
    //临时结算工资
    function _partialPaid(Employee employee) private {
        // require(msg.sender == owner);
        if (employee.id != 0x0){
            // uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
            employee.id.transfer(payment);
        }
    }
    

    //添加员工信息
    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNonExist(employeeId){
        uint sa = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId,sa,now);
        salarysum += sa;
    }
    
    //删除员工信息
    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId){
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);
        salarysum -= employee.salary;
        delete employees[employeeId];
        
    }
    
    //更新员工工资
    function updateEmployee(address employeeId, uint salary) public onlyOwner  employeeExist(employeeId){
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);
        uint sa = salary.mul(1 ether);
        salarysum = salarysum.add(sa).sub(employee.salary);
        employees[employeeId].salary = sa;
        employees[employeeId].lastPayday = now;
    }
    
    //由员工自己更换员工地址，需要满足一个付款周期
    function changePaymentAddress(address employeeId) public  employeeExist(msg.sender) employeeNonExist(employeeId) moreThanpayDuration(employeeId){
        Employee storage employee = employees[msg.sender];
        _partialPaid(employee);
        
        employees[employeeId] = Employee(employeeId,employee.salary,now);
        delete employees[msg.sender];
    }
    
    
    //向合约中打款
    function addFund() payable public onlyOwner returns (uint) {
        return address(this).balance;
    }

    //获取合约的信息，地址和余额
    function getOwnerinfo() public onlyOwner view returns (address owneraddress,uint balance,uint salarytotal){
        owneraddress = owner;
        salarytotal = salarysum;
        balance = address(this).balance;
    }
    
    //获取员工信息，地址和工资
    function getEmployeeinfo(address employeeId) public view   employeeExist(employeeId) returns (uint salary,uint lastPayday){
        Employee storage employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    
    //计算合约的余额能支付多少次工资
    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(salarysum);
    }
    
    //确认当前余额能否支付下一次工资
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    //员工向合约申请工资,含账号地址验证
    function getPaid() public  employeeExist(msg.sender) moreThanpayDuration(msg.sender){
        Employee storage employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

    }
}
