/*作业请提交在这个目录下*/

完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化
address                                          transaction cost               execution cost
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c       22966                          1694
0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db       23747                          2475
0x583031d1113ad414f02576bd6afabfb302140225       24528                          3256
0xdd870fa1b7c4700f2bd7f44238821c26f7392148       25309                          4037
0x37a79142899983ab4e05a0905b7c075d04073a0b       26090                          4818
0x0baaf26dfa87a8faac1524db8abeac10da3a29eb       26871                          5599
0x1d8eb5d264141243ce5089208dbb68cc6ff44ce6       27652                          6380
0x10c2f08b1c52442022b9bc439bc72c1e431f3e00       28433                          7161
0x73b71be331e2eaa1fd7b097fea39e15c144d0246       29214                          7942
0xe9f6e55b1e4c49dfb16f74c7558ce11256a81ff5       29995                          8723

很明显，随着用户数量的增加，transaction cost 和 execution cost 都线性增长（约800gas/用户）。code里的calculate runway调用了循环语句的sum功能的任务量线性增加，
自然总的计算量增加。一个简单的改进是：把totalSalary作为全局变量保存，这样每次只用在全局变量上加上现有的新值即可。

Test of the performance of improved code:

address                                          transaction cost               execution cost
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c       22124                          852
0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db       22124                          852
0x583031d1113ad414f02576bd6afabfb302140225       22124                          852

Code after improvement:

pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if(employee.id !=0x0){
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=0; i<employees.length; i++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee,index)  = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether,now));
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        employees[index].lastPayday = now;
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;

        
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return this.calculateRunway()>0;
    }
    
    function getPaid() {
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        assert(now - employee.lastPayday > payDuration);
        uint nextPayday = employee.lastPayday + payDuration;
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
