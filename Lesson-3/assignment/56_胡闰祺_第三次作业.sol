/*作业请提交在这个目录下*/

/*作业请提交在这个目录下*/

############################################## Codes for Question 1. and Question 2. #########################################

pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address EmployeeAddress;
        uint salary;
        uint lastPayday;
    }

    mapping(address => Employee) public employees;

    uint constant payDuration = 30 seconds;
    
    address OwnerAddress;
    
    uint totalSalary = 0;
    
    address thisAddress = this;  
   
    function Payroll() public {
        OwnerAddress = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == OwnerAddress);
        _;
    }
    
    modifier employeeExist(address curr_EmployeeAddress) {
        
        var curr_employee = employees[curr_EmployeeAddress];
        assert(curr_employee.EmployeeAddress != 0x0);
        _;
        
    }
    
    function addEmployee(address curr_EmployeeAddress, uint curr_salary) onlyOwner {
    
        assert(employees[curr_EmployeeAddress].EmployeeAddress == 0x0);
        
        uint unitSalary = curr_salary * 1 ether;
        employees[curr_EmployeeAddress] = Employee(curr_EmployeeAddress, unitSalary, now);
        
        totalSalary += unitSalary;
        
    }
    
    modifier partialPay(address curr_EmployeeAddress) {
    
        _partialPay(employees[curr_EmployeeAddress]);
        _;
        
    }
    function _partialPay(Employee employee) private {
    
        uint tempSalary = employee.salary * (now - employee.lastPayday);
        tempSalary = tempSalary / payDuration;
        
        employee.EmployeeAddress.transfer(tempSalary);
        
    }
    
    
   function removeEmployee(address curr_EmployeeAddress) onlyOwner employeeExist(curr_EmployeeAddress) partialPay(curr_EmployeeAddress) {
        
        var curr_employee = employees[curr_EmployeeAddress];
        totalSalary -= curr_employee.salary;
        
        delete employees[curr_EmployeeAddress];
        
    }
    
    function updateEmployee(address curr_EmployeeAddress, uint new_salary) onlyOwner employeeExist(curr_EmployeeAddress) partialPay(curr_EmployeeAddress) {
        
        var curr_employee = employees[curr_EmployeeAddress];
        
        uint unitSalary = new_salary * 1 ether;
        totalSalary = totalSalary - curr_employee.salary + unitSalary;

        curr_employee.salary = unitSalary;
        curr_employee.lastPayday = now;
        
    }
    
    function changePaymentAddress(address curr_EmployeeAddress, address new_EmployeeAddress) onlyOwner employeeExist(curr_EmployeeAddress) partialPay(curr_EmployeeAddress) {
        
        var curr_employee = employees[curr_EmployeeAddress];
        
        curr_employee.EmployeeAddress = new_EmployeeAddress;
        
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
    
    function getPaid() employeeExist(msg.sender){
    
        var curr_employee = employees[msg.sender];
        
        var newPayday = curr_employee.lastPayday + payDuration;
        assert(newPayday < now);
        
        curr_employee.lastPayday = newPayday;
        curr_employee.EmployeeAddress.transfer(curr_employee.salary);
        
    }    
}

################################################### Snapshots for Question 1. ##############################################
### attached ###

######################################################### Question 3. ######################################################

       |-----> B-----|
       |             |------> K1------|
O ---->|-----> A--|--|                |-----> Z
       |          |---------> K2------|
       |-----> C--|
