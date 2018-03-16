/*
加入员工时，calculateRunway这个函数gas变化如下：

transaction cost, execution cost

22966 1694

23747 2475

23528 3256

25309 4037

26090 4818

26871 5599

27652 6380

28433 7161

29214 7942

29995 8723

可以看到，在calculateRunway函数中，因为employees数组的长度不断增大，遍历这个数组所需要的gas也不断增大，所以需要把计算salary放在别的地方。

*/

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;
    uint totalSalary =0;

    function Payroll() {
        owner = msg.sender;
    }
    
    
    function _partialPaid(Employee employee) private {
        uint payment =  employee.salary * (now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if( employeeId == employees[i].id ){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(owner == msg.sender);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary += salary* 1 ether;
        employees.push(Employee(employeeId, salary* 1 ether, now));
        
    }
    
    function removeEmployee(address employeeId) {
        require(owner == msg.sender);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        totalSalary += employee.salary* 1 ether;
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -=1;
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(owner == msg.sender);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        totalSalary -= employee.salary* 1 ether;
        _partialPaid(employee);
        totalSalary += salary * 1 ether;
        employee.lastPayday = now;
        employee.salary = salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
         return calculateRunway()>0;
    }
    
    function getPaid() {

       var (employee,index) = _findEmployee(msg.sender);
       require(employee.id == msg.sender);
       
       uint nextPayday = employee.lastPayday+payDuration;
       require(nextPayday<now);
       
       employee.lastPayday = nextPayday;
       employee.id.transfer(employee.salary);
       
    }
}
