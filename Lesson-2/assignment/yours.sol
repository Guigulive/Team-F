/*作业请提交在这个目录下*/

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
        employees.push(Employee(employeeId, salary* 1 ether, now));
    }
    
    function removeEmployee(address employeeId) {
        require(owner == msg.sender);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -=1;
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(owner == msg.sender);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employee.lastPayday = now;
        employee.salary = salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
      for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
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
