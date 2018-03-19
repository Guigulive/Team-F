pragma solidity ^0.4.14;

contract Payrool {
    struct Employee{
        address employeeAddress;
        uint salary;
        uint lastPayday;
    }
   Employee[] employeeArray;
   uint constant payDuration = 30 seconds;
   address ownerAddress;
   uint totalSalary = 0;
   
   
   function Payrool() payable{
       ownerAddress = msg.sender;
   }
   function _partialPay(Employee emp) private{
       uint totalSalary = emp.salary *(now - emp.lastPayday)/payDuration;
       emp.employeeAddress.transfer(totalSalary);
   }
   function _findEmployee(address addr) private returns (Employee,uint){
       
       for( uint i = 0; i < employeeArray.length;i++){
           if(employeeArray[i].employeeAddress == addr){
              return(employeeArray[i],i);    
           }
       }
   }
   
   function addEmployee(address addr,uint sal){
       require(ownerAddress == msg.sender);
       
       var(emp,index)=_findEmployee(addr);
       require(emp.employeeAddress == 0x0);
       uint oneSalary = sal*1 ether;
       totalSalary = totalSalary+oneSalary;
       employeeArray.push(Employee(addr,oneSalary,now));
   }
   function removeEmployee(address addr){
       require(ownerAddress == msg.sender);
       var (emp,index) = _findEmployee(addr);
       assert(emp.employeeAddress != 0x0);
       
       totalSalary = totalSalary - emp.salary;
       delete(employeeArray[index]);
       employeeArray[index] = employeeArray[employeeArray.length-1];
       employeeArray.length -=1;
   }
   function updateEmployee(address oldAddress,address newAddresss,uint sal) {
       
        require(ownerAddress == msg.sender);
        
        var(emp,index) = _findEmployee(oldAddress);
        assert(emp.employeeAddress != 0x0);
        uint oneSalary = sal * 1 ether;
        totalSalary = totalSalary - emp.salary + oneSalary;
        emp.employeeAddress = newAddresss;
        emp.salary = oneSalary;
        
   }
   

   
   function calculateRunway() view returns(uint){
     
       uint selfbalance = getAddressBalance(this);
       return selfbalance / totalSalary;
   }
    function hasEnoughFund() returns(bool){
       return calculateRunway() > 0;
   }
  
   function addFund() payable returns(uint){
       
       return this.balance;
   }
   
   
   function getPaid() {
       var (emp,index) = _findEmployee(msg.sender);
       require(msg.sender == emp.employeeAddress);
       
       uint intervalTime = now - emp.lastPayday;
       require(intervalTime >= payDuration);
       
       uint times = intervalTime/payDuration;
       employeeArray[index].lastPayday = emp.lastPayday + times*payDuration;
       employeeArray[index].employeeAddress.transfer(emp.salary*times);
   }
   
   function getAddressBalance(address addr) public view returns(uint){
       return addr.balance;
   }
  
}

总结：
智能合约每执行一句都需要消耗gas，当calculateRunway采用循环遍历的方法每次都计算totalSalary时，下一次的操作会与上一次的操作有重复的部分，
这里是可以优化的部分。通过存储将当前totalSalary存储到storage上，减少遍历次数，减少gas消耗。

智能合约中应该避免重复操作，避免循环遍历。

calculateRunway方法优化前后的 gas消耗对比
"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c”,1
23036    22202
1764       930

"0x14723a09acff6d2a60dcdf7aa4aff308fddc161c”,1
23817    22202
2545    930

"0x14723a09acff6d2a60dcdf7aa4aff308fddc162c”,1
24598    22202
3326    930

"0x14723a09acff6d2a60dcdf7aa4aff308fddc163c”,1
25379
4107

"0x14723a09acff6d2a60dcdf7aa4aff308fddc164c”,1
26160
4888

"0x14723a09acff6d2a60dcdf7aa4aff308fddc165c”,1
26941
5669

"0x14723a09acff6d2a60dcdf7aa4aff308fddc166c”,1
27722
6450

"0x14723a09acff6d2a60dcdf7aa4aff308fddc167c”,1
28503
7231

"0x14723a09acff6d2a60dcdf7aa4aff308fddc168c”,1
29284
8012

"0x14723a09acff6d2a60dcdf7aa4aff308fddc169c”,1
30065
8793
