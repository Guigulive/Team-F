/*作业请提交在这个目录下*/
============
优化前代码   |
===============================================================================================================
pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    address private thisAddress = this;
    uint private constant payDuration = 10 seconds;
    
    address private owner;
    Employee[] employees;
    
    function Payroll() public {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0) {
            employee.id.transfer((now-employee.lastPayday)*employee.salary/payDuration);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if(employeeId == employees[i].id) {
                return (employees[i], i);
            }
        }
    }
    
    function getEmployeeNumber() view returns (uint) {
        return employees.length;
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[idx];
        employees[idx] = employees[employees.length-1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeId, uint s) public {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        
        _partialPaid(employee);
        employees[idx].salary = s * 1 ether;
        employees[idx].lastPayday = now;
    }
    
    function addFund() payable public returns (uint)  {
        return thisAddress.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        uint totalSalary = 0;
        for(uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return thisAddress.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public{
        var (employee, idx) = _findEmployee(msg.sender);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

==============================================================================================================

calculateRunway()的gas变化(优化前)

   employee address                             |  transaction cost  |  excution cost  |
---------------------------------------------------------------------------------------|
1. 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   |  23984             |  2712           |
2. 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   |  24765             |  3493           |
3. 0x583031d1113ad414f02576bd6afabfb302140225   |  25546             |  4274           |
4. 0xdd870fa1b7c4700f2bd7f44238821c26f7392148   |  26327             |  5055           |
5. 0x9204614a80776af4254bb952e664453aa865d465   |  27108             |  5836           |
6. 0x1138ac13089c81eec5143671e176bc67c24ad2bc   |  27889             |  6617           |
7. 0x1a1c6d3fd95ff828f7a5dac49117c199ed6fd792   |  28670             |  7398           |
8. 0xdeb1d8567cdfed449fefc37d4c32c56355eb9c1e   |  29451             |  8179           |
9. 0x6b6b26075f06c229e394dc3cbe0c4838b15c8c1e   |  30232             |  8960           |
10.0x6141576dd13464db8907d2afe82c2989dfdbb3b9   |  31013             |  9740           |
---------------------------------------------------------------------------------------- 
可以看见gas的消耗是越来越大的，因为当前的calculateRunway函数里面有个循环，当employee逐渐增多时，循环次数会越来越多，所以计算消耗越大。
并且通过计算可以发现gas消耗是线性增长，可以把这个理解为算法复杂度，此处为O(n)
============
优化后代码   | 主要变化是提取totalSalary成为一个全局变量来维护
===============================================================================================================
pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    address private thisAddress = this;
    uint private constant payDuration = 10 seconds;
    
    address private owner;
    Employee[] employees;
    
    uint totalSalary;
    
    function Payroll() public {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0) {
            employee.id.transfer((now-employee.lastPayday)*employee.salary/payDuration);
        }
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++) {
            if(employeeId == employees[i].id) {
                return (employees[i], i);
            }
        }
    }
    
    function getEmployeeNumber() view returns (uint) {
        return employees.length;
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[idx].salary;
        
        delete employees[idx];
        employees[idx] = employees[employees.length-1];
        employees.length -= 1;
        
    }
    
    function updateEmployee(address employeeId, uint s) public {
        require(msg.sender == owner);
        var (employee, idx) = _findEmployee(employeeId);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        totalSalary += s * 1 ether;
        employees[idx].salary = s * 1 ether;
        employees[idx].lastPayday = now;
    }
    
    function addFund() payable public returns (uint)  {
        return thisAddress.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return thisAddress.balance / totalSalary;
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() public{
        var (employee, idx) = _findEmployee(msg.sender);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

==============================================================================================================

calculateRunway()的gas变化(优化后)

   employee address                             |  transaction cost  |  excution cost  |
---------------------------------------------------------------------------------------|
1. 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   |  22361             |  1089           |
2. 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   |  22361             |  1089           |
3. 0x583031d1113ad414f02576bd6afabfb302140225   |  22361             |  1089           |
4. 0xdd870fa1b7c4700f2bd7f44238821c26f7392148   |  22361             |  1089           |
5. 0x9204614a80776af4254bb952e664453aa865d465   |  22361             |  1089           |
6. 0x1138ac13089c81eec5143671e176bc67c24ad2bc   |  22361             |  1089           |
7. 0x1a1c6d3fd95ff828f7a5dac49117c199ed6fd792   |  22361             |  1089           |
8. 0xdeb1d8567cdfed449fefc37d4c32c56355eb9c1e   |  22361             |  1089           |
9. 0x6b6b26075f06c229e394dc3cbe0c4838b15c8c1e   |  22361             |  1089           |
10.0x6141576dd13464db8907d2afe82c2989dfdbb3b9   |  22361             |  1089           |
---------------------------------------------------------------------------------------- 
经过优化后，可以发现gas消耗变成常数，即O(1)

