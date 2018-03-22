/*作业请提交在这个目录下*/

#第一题：
- 第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图
函数的截图保存到Lesson-3/assigment/image/ 下面了

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
    mapping (address=>Employee) employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        if(employee.id !=0x0){
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    


    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee  = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether,now);
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;

        delete employees[employeeId];

    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        employees[employeeId].lastPayday = now;
        _partialPaid(employee);
        totalSalary += (salary - employee.salary) * 1 ether;
        employees[employeeId].salary = salary * 1 ether;

        
    }
    
    function checkEmployee(address employeeId) returns(uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
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
        var employee = employees[msg.sender];
        assert(employee.id != 0x0);
        assert(now - employee.lastPayday > payDuration);
        uint nextPayday = employee.lastPayday + payDuration;
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}

# 第二题
- 第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能
Code 如下：
Follow 老师的讲解，用了两个modifier

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
    mapping (address=>Employee) public employees;
    
    function Payroll() {
        owner = msg.sender;
    }
    
     modifier onlyOwner {
         //like decorator in python. but litttle different
        require(msg.sender == owner);
        // replace the code before the function

        _;
    }

    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        if(employee.id !=0x0){
            uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
            employee.id.transfer(payment);
        }
    }
    


    function addEmployee(address employeeId, uint salary) onlyOwner{
        var employee  = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether,now);
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;

        delete employees[employeeId];

    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        employees[employeeId].lastPayday = now;
        _partialPaid(employee);
        totalSalary += (salary - employee.salary) * 1 ether;
        employees[employeeId].salary = salary * 1 ether;

        
    }
    
    function changePaymentAddress(address newEmployeeId) {
        var employee = employees[msg.sender];
        uint salary = employee.salary;
        uint lastPayday = employee.lastPayday;
        delete employees[msg.sender];
        employees[newEmployeeId] = Employee(newEmployeeId,salary,lastPayday);
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
    
    function getPaid()  employeeExist(msg.sender){
        var employee = employees[msg.sender];
        assert(now - employee.lastPayday > payDuration);
        uint nextPayday = employee.lastPayday + payDuration;
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}

#第三题
- 第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线
- contract O
- contract A is O
- contract B is O
- contract C is O
- contract K1 is A, B
- contract K2 is A, C
- contract Z is K1, K2 
