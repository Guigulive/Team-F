pragma solidity ^0.4.14;
import './SafeMath.sol';

contract Payroll {
    
    using SafeMath for uint;
    
    struct Employee{
        address employeeAddress;
        uint salary;
        uint lastPayday;
    }
   mapping(address => Employee) public employeeMapping;
   uint constant payDuration = 30 seconds;
   address ownerAddress;
   uint totalSalary = 0;
   
   modifier onlyOwner{
       require(ownerAddress == msg.sender);
       _;
   }
   modifier employeeExist(address addr){
       var employee = employeeMapping[addr];
       require(employee.employeeAddress != 0x0);
       _;
   }
   function Payroll() payable{
       ownerAddress = msg.sender;
   }
   function _partialPay(Employee emp) private{
       uint totalSalary = emp.salary.mul(now.sub(emp.lastPayday)).div(payDuration);
       
       emp.employeeAddress.transfer(totalSalary);
   }
  
   function addEmployee(address addr,uint sal) onlyOwner {
      
       uint oneSalary = sal.mul(1 ether);
       totalSalary = totalSalary.add(oneSalary);
       employeeMapping[addr] = Employee(addr,oneSalary,now);
   }
   function removeEmployee(address addr) onlyOwner employeeExist(addr){
       var employee = employeeMapping[addr];
       totalSalary = totalSalary.sub(employee.salary);
       _partialPay(addr);
       delete(employeeMapping[addr]);
      
   }
   function updateEmployee(address oldAddress,address newAddresss,uint sal) onlyOwner employeeExist(oldAddress){

        var employee = employeeMapping[oldAddress];
        uint oneSalary = sal.mul(1 ether);
        totalSalary = totalSalary.sub(employee.salary).add(oneSalary);
        employee.employeeAddress = newAddresss;
        employee.salary = oneSalary;
        
   }
   function changePaymentAddress(address oldAddress,address newAddresss) onlyOwner employeeExist(oldAddress){
       var employee = employeeMapping[oldAddress];
       employee.employeeAddress = newAddresss;
   }

   
   function calculateRunway() view returns(uint){
     
       uint selfbalance = getAddressBalance(this);
       return selfbalance.div(totalSalary);
   }
    function hasEnoughFund() returns(bool){
       return calculateRunway() > 0;
   }
  
   function addFund() payable  returns(uint){
       
       return this.balance;
   }
   
   
   function getPaid() employeeExist(msg.sender) {
       var employee = employeeMapping[msg.sender];
       uint intervalTime = now.sub(employee.lastPayday);
       require(intervalTime >= payDuration);
       
       uint times = intervalTime.div(payDuration);
       employee.lastPayday = employee.lastPayday.add(times.mul(payDuration));
       employee.employeeAddress.transfer(employee.salary.mul(times));
   }
   
   function getAddressBalance(address addr) public view returns(uint){
       return addr.balance;
   }
  
}
