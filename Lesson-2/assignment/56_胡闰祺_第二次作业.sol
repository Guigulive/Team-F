/*作业请提交在这个目录下*/

Question 1. 每增加一个员工address, execution cost由最初的1628每次增加780, 同时transaction cost也由最初的22960逐次增加780. 
原因是calculateRunway函数利用for循环，每次遍历每一个employee，因此每增加一个employee，运行的cost也会线性增加。

Question 2. 解决的方法之一是将总的total_Salary作为一个全局变量，取代之前calculateRunway函数里的局部变量totalSalary.
这样，每增加一个员工，只会增加一次计算量，从而减少cost。
    
优化后的代码为：
-------------------------------
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;

    uint total_Salary = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if(employee.id != 0x0){
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        uint total_employee = employees.length;
        for (uint i=0; i < total_employee; i++){
            if (employees[i].id == employeeId){
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee,ind)  = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        total_Salary = total_Salary + salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, ind) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[ind];
        uint total_employee = employees.length;
        employees[ind] = employees[total_employee - 1];
        employees.length = employees.length - 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, ind) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        employees[ind].lastPayday = now;
        _partialPaid(employee);
        employees[ind].salary = salary * 1 ether;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint total_employee = employees.length;
        for (uint i = 0; i < total_employee; i++) {
            total_Salary = total_Salary + employees[i].salary;
        }
        return this.balance / total_Salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return this.calculateRunway() > 0;
    }
    
    function getPaid() {
        var(employee,ind) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        assert(now - employee.lastPayday > payDuration);
        employees[ind].lastPayday = employee.lastPayday + payDuration;
        employee.id.transfer(employee.salary);
    }
}
----------------------------

经过修改，每次运行的transaction cost都变为22196，execution cost都变为852，不在对employees人数敏感。
