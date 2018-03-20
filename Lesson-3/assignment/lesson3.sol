/*作业请提交在这个目录下*/

pragma solidity ^0.4.14;

contract Payroll{
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration  = 10 seconds;
    address owner;
    uint totalSalary = 0;
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    //Employee[] employees;
    //构造函数
    function Payroll(){
        owner = msg.sender;
    }
    
    function partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }
    
    
    //mapping(address => Employee) employees;
    mapping(address => Employee) public employees;
    
    
   /*    
   function findEmployee(address employee) private returns(Employee,uint) {
        for(uint i= 0; i< employees.length; i++){
            if(employees[i].id == employee){
                return (employees[i],i);
            }
        
        }
    }*/
    
    //onlyOwner use
    function addEmployee(address employeeId,uint salary) onlyOwner
    {
        //require(msg.sender == owner);
        //var (employee,index) = findEmployee(employeeId);
        var employee = employees[employeeId];
        //solidity循环
        /*for(uint i= 0; i< employees.length; i++){
            if(employees[i].id == employee){
                revert();
            }
        }*/
        //Employee memory employee = findEmployee(employeeId);
        assert(employee.id == 0x0);
        totalSalary+=salary * 1 ether;
        employees[employeeId]=Employee(employeeId,salary* 1 ether,now);
        //employees.push((employee,salary,now));
    }
    
    
    /*   
    function addEmployee(address employeeId,uint salary)
    {
        require(msg.sender == owner);
        //var (employee,index) = findEmployee(employeeId);
        var employee = employees[employeeId];
        //solidity循环
        for(uint i= 0; i< employees.length; i++){
            if(employees[i].id == employee){
                revert();
            }
        }
        //Employee memory employee = findEmployee(employeeId);
        //assert(employee.id == 0x0);
        //totalSalary+=salary * 1 ether;
        //employees[employeeId]=Employee(employeeId,salary* 1 ether,now);
        //employees.push((employee,salary,now));
    }
    */
    
    function removeEmployee(address employeeId)
    {
        require(msg.sender == owner);
        //var (employee,index) = findEmployee(employeeId);
        var employee = employees[employeeId];
        assert(employeeId != 0x0);
        //partialPaid(employee[index]);
        partialPaid(employee);
        //delete employee[index];
        totalSalary-=employees[employeeId].salary;
        delete employees[employeeId];
 /*     employees[index] = employees[employees.length-1];
        employees.length -=1;*/
    }
    
    
    function updateEmployee(address employeeId,uint salary){
        require(msg.sender==owner);
        var employee = employees[employeeId];
        //var (employee,index) = findEmployee(employeeId);
        assert(employee.id != 0x0);
        /*       
        partialPaid(employees[index]);
        employees[index].salary = salary;
        employees[index].lastPayday = now;*/
        partialPaid(employee);
        totalSalary-=employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary+=employees[employeeId].salary;
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint)
    {
/*        for (uint i=0;i < employees.length ;i++){
            totalSalary+=employees[i].salary;
        }*/
        return this.balance/totalSalary;    
    }
    
    function hasEnoughFund() returns(bool)
    {
        return calculateRunway()>0;
    }
    //员工信息
    /*    
    function checkEmployee(address employeeId) returns(uint,uint)
    {
        var employee = employees[employeeId];
        return(employee.salary,employee.lastPayday);
    }*/
    
    function checkEmployee(address employeeId) returns(uint salary,uint lastPayday)
    {
        var employee = employees[employeeId];
        //return(employee.salary,employee.lastPayday);
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
/*    function getPaid()
    {
        var employee = employees[msg.sender];
        assert(employee.id!=0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday<now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }*/
    
    function getPaid() employeeExist(msg.sender)
    {
        var employee = employees[msg.sender];
        //assert(employee.id!=0x0);
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday<now);
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
}
