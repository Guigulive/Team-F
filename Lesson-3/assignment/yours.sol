pragma solidity ^0.4.18;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    address owner;
    uint totalSalary = 0;
    
    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNonExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    modifier partialPaid(address employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        _;
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary
        .mul(now.sub(employee.lastPayday))
        .div(payDuration);
        employee.id.transfer(payment);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNonExist(employeeId){
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) 
    partialPaid(employeeId){
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner 
    employeeExist(employeeId) partialPaid(employeeId){
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }
    
    function changePaymentAddress(address newAddress) employeeExist(msg.sender) employeeNonExist(newAddress){
        var oldEmployee = employees[msg.sender];
        employees[newAddress] = Employee(newAddress, oldEmployee.salary, oldEmployee.lastPayday);
        delete employees[msg.sender];
    } 
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance/totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    

    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
