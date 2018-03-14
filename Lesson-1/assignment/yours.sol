pragma solidity ^0.4.14;

contract Payrool {
    
   uint lastPayday = now;
   uint constant payDuration = 10 seconds;
   
   address ownerAddress;
   address employeeAddress ;
   uint salary = 1 ether;
   
   function Payrool() payable{
       ownerAddress = msg.sender;
   }
    function getAddressBalance(address addr) view returns(uint){
       return addr.balance;
   }
   function calculateRunway() view returns(uint){
       return this.balance / salary;
   }
    function hasEnoughFund() returns(bool){
       return calculateRunway() > 0;
   }
  
   function addFund() payable returns(uint){
       
       return this.balance;
   }
   function changeSalary(uint x){
       require(ownerAddress == msg.sender);
       salary = x * 1 ether;
   }
   
   function changeEmployeeAddress(address a) returns(address){
        require(ownerAddress == msg.sender);
        employeeAddress = a;
        return employeeAddress;
   }
   function getEmployee() view public returns (address) {
       return employeeAddress;
   }
   function getPaid() {
       
       require(msg.sender == employeeAddress);
       
       uint intervalTime = now - lastPayday;
       require(intervalTime >= payDuration);
       
       uint times = intervalTime/payDuration;
       lastPayday = lastPayday + times*payDuration;
       employeeAddress.transfer(salary*times);
   }
   
  
}

