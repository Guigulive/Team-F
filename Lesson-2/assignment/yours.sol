/*作业请提交在这个目录下*/
现在我的代码还有点问题，正在修改当中
/*
transact to Payroll.addEmployee errored: VM error: invalid opcode.
invalid opcode	
	The execution might have thrown.
	Debug the transaction to get more information. 
*/
gas消费应该是增加的，因为每一次都会多执行for循环
代码现在正在修改中ing

pragma solidity ^0.4.14;
contract Payroll{
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration  = 10 seconds;
    address owner;
    
    Employee[] employees;
    
    //测试函数
    function getEmployee()
    {
        for(uint i=0;i<employees.length;i++ ){
            //return (employees[i],i);
        }
    }
    
    //构造函数
    function Payroll(){
        owner = msg.sender;
    }
    //应付的ETH
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now-employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    //查找用户是否存在
    function _findEmployee(address employee) private returns(Employee storage,uint)
    {
        for(uint i= 0; i< employees.length; i++){
            if(employees[i].id == employee){
                return (employees[i],i);
            }
        
        }
    }
    //添加用户
    function addEmployee(address employeeId,uint salary)
    {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employeeId == 0x0);
        assert(index > 10);
        employees.push(Employee(employeeId,salary,now));
    }
    
    //删除用户
    function removeEmployee(address employeeId)
    {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employeeId != 0x0);
        _partialPaid(employees[index]);
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -=1;
    }
    
    //更新用户信息
    function updateEmployee(address employeeId,uint salary){
        require(msg.sender==owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employees[index]);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
    }
    
    //能够支付多少薪水
    function calculateRunway() returns(uint){
        uint totalSalary = 0;
        for(uint i= 0; i< employees.length; i++){
            totalSalary+=employees[i].salary;
        }
        return this.balance/totalSalary;
    }
    
    //支付薪水
    function getPaid()
    {
        var(employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayday = employee.lastPayday+payDuration;
        assert(nextPayday<now);
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
    //合约中的ETH
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
}
