Original code:

pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    
    Employee[] employees;
    
    uint constant payDuration = 10 seconds;
    address owner;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmpolyee(address employeeId) private returns (Employee,uint) {
        for (uint i=0; i <employees.length;i++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender==owner);
        var(employee, index) = _findEmpolyee(employeeId);
        assert(employee.id==0x0);
        
        employees.push(Employee(employeeId,salary* 1 ether,now));
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender==owner);
        var(employee, index) = _findEmpolyee(employeeId);
        assert(employee.id!=0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length-=1;
        return;
        
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var(employee, index) = _findEmpolyee(employeeId);
        assert(employee.id!=0x0);
        
         _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday=now;
        return;
        
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    
    function calculateRunway() returns (uint) {
        uint totalSalary=0;
        for (uint i=0; i <employees.length;i++){
            totalSalary +=employees[i].salary;
        }
        return this.balance/totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index) = _findEmpolyee(msg.sender);
        assert(employee.id!=0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}


Gas cost for adding employees:
transaction cost | execution cost
22971 | 1699
23759 | 2487
24547 | 3275
25335 | 4063
26123 | 4851
26911 | 5639
27699 | 6427
28487 | 7215
29275 | 8003
30063 | 8791

Gas increases with adding more employees. Because to add more employees to the contract, it consumes more calculation power in the calculateRunway function(more loops for more employees).


Updated code:

pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee{
        address id;
        uint salary;
        uint lastPayday;
    }
    
    Employee[] employees;
    uint totalSalary;
    
    uint constant payDuration = 10 seconds;
    address owner;
    
    function Payroll(){
        owner = msg.sender;
        totalSalary = 0;
    }
    
    function _partialPaid(Employee employee) private{
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmpolyee(address employeeId) private returns (Employee,uint) {
        for (uint i=0; i <employees.length;i++){
            if (employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender==owner);
        var(employee, index) = _findEmpolyee(employeeId);
        assert(employee.id==0x0);
        
        employees.push(Employee(employeeId,salary* 1 ether,now));
        totalSalary += salary* 1 ether;
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender==owner);
        var(employee, index) = _findEmpolyee(employeeId);
        assert(employee.id!=0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[index].salary* 1 ether;
        
        delete employees[index];
        employees[index]=employees[employees.length-1];
        employees.length-=1;
        
        return;
        
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var(employee, index) = _findEmpolyee(employeeId);
        assert(employee.id!=0x0);
        
        _partialPaid(employee);
        totalSalary += (salary-employees[index].salary) * 1 ether;
         
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday=now;
        
        return;
        
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    
    function calculateRunway() returns (uint) {
    //    uint totalSalary=0;
    //    for (uint i=0; i <employees.length;i++){
    //        totalSalary +=employees[i].salary;
    //    }
        return this.balance/totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee,index) = _findEmpolyee(msg.sender);
        assert(employee.id!=0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}


Explain: I basically move the totalSalary part calculation into the addEmployee, removeEmployee, updateEmployee functions. Everytime I call these functions, totalSalary will be modified at the same time. Although it increases the cost of these three functions, the total cost should be less because everytime we call calculateRunway function, there is no need to calculate the totalSalary again.

After optimization, adding employees doesn't change the cost. They are always 22122 | 850 for transaction gas|execution gas, respectively.
