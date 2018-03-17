pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    
    uint constant payDuration = 10 seconds;
    
    Employee[] employees;
    address owner;
    uint salarysum = 0;

    
    //初始化，设置owner,lastPayday
    function Payroll() public{
        owner = msg.sender;
    }
    
    //临时结算工资
    function _partialPaid(Employee employee) private {
        // require(msg.sender == owner);
        if (employee.id != 0x0){
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    
    //查找成员，返回成员及数组索引
    function _findEmployee(address employeeId) private view returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    //添加员工信息
    function addEmployee(address employeeId, uint salary) public{
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint sa = salary * 1 ether;
        employees.push(Employee(employeeId,sa,now));
        salarysum += sa;
    }
    
    //删除员工信息
    function removeEmployee(address employeeId) public{
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        salarysum -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
        
    }
    
    //更新员工工资
    function updateEmployee(address employeeId, uint salary) public{
        require(msg.sender == owner);
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        uint sa = salary * 1 ether;
        salarysum += employee.salary - salary;
        employees[index].salary = sa;
        employees[index].lastPayday = now;
        employees.length -= 1;
    }
    
    //更换员工地址
    function updateEmployeeid(address employeeId) public{
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        employees[index].id = employeeId;
        employees[index].lastPayday = now;
    }
    
    
    
    //向合约中打款
    function addFund() payable public returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }

    //获取合约的信息，地址和余额
    function getOwnerinfo() public view returns (address,uint){
        require(msg.sender == owner);
        return (owner,this.balance);
    }
    
    //获取员工信息，地址和工资
    function getEmployeeinfo(address employeeId) public view  returns (address,uint){
        var(employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        return (employee.id,employee.salary);
        
    }
    
    
    //计算合约的余额能支付多少次工资
    function calculateRunway() public view returns (uint) {
        return this.balance / salarysum;
    }
    
    //确认当前余额能否支付下一次工资
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    //员工向合约申请工资,含账号地址验证
    function getPaid() public{
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employees[index].salary);

    }
}
