/*作业请提交在这个目录下*/

=========================================================================================
第一题：完成今天所开发的合约产品化内容，使用Remix调用每一个函数，提交函数调用截图                    |
=========================================================================================

https://github.com/yyssjj33/Team-F/raw/53-%E6%9D%A8%E6%A5%AB/Lesson-3/assignment/%E4%BD%9C%E4%B8%9A%E4%B8%89%E7%AC%AC%E4%B8%80%E9%A2%98%E6%88%AA%E5%9B%BE.zip



=========================================================================================
第二题：增加 changePaymentAddress 函数，更改员工的薪水支付地址，思考一下能否使用modifier整合某个功能|
=========================================================================================
可以整合partialPaid和employeeNonExist函数到modifier

modifier partialPaid(employeeId) {
    _partialPaid(employees[employeeId]);
    _;
}

modifier employeeNonExist(address employeeId) {
    var employee = employees[employeeId];
    assert(employee.id == 0x0);
    _;
}
    
function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress)employeeNonExist(newAddress) partialPaid(oldAddress) {
    var employee = employees[oldAddress];
    var newEmployee = Employee(newAddress, employee.salary * 1 ether, now);
    delete employees[oldAddress];
    employees[newAddress] = newEmployee;
}

完整代码
---------------------------------------------------------------------
pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    address thisAddress = this;
    uint constant payDuration = 10 seconds;
    
    address owner;
    mapping(address => Employee) public employees;
    
    uint totalSalary;
    
    function Payroll() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier partialPaid(address employeeId) {
        _partialPaid(employees[employeeId]);
        _;
    }
    
    modifier employeeNonExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        if (employee.id != 0x0) {
            employee.id.transfer((now-employee.lastPayday)*employee.salary/payDuration);
        }
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner employeeNonExist(employeeId){
        var employee = employees[employeeId];
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) partialPaid(employeeId){
        var employee = employees[employeeId];
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, uint s) onlyOwner employeeExist(employeeId) partialPaid(employeeId){
        var employee = employees[employeeId];
        
        totalSalary -= employee.salary;
        totalSalary += s * 1 ether;
        employees[employeeId].salary = s * 1 ether;
        employees[employeeId].lastPayday = now;
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeNonExist(newAddress) partialPaid(oldAddress){
        require(newAddress != 0x0);
        var employee = employees[oldAddress];
        var newEmployee = Employee(newAddress, employee.salary * 1 ether, now);
        delete employees[oldAddress];
        employees[newAddress] = newEmployee;
        
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
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }    
}
---------------------------------------------------------------------



=========================================================================================
第三题（加分题）：自学C3 Linearization, 求以下 contract Z 的继承线                            |
contract O                                                                              |
contract A is O                                                                         |
contract B is O                                                                         |
contract C is O                                                                         |
contract K1 is A, B                                                                     |
contract K2 is A, C                                                                     |
contract Z is K1, K2                                                                    |
=========================================================================================
    O
 /  |  \
A   B   C
| \ /   |
| / \   | 
 k1   k2
   \  /
    Z
    
    
L[O] = O
L[C] = C + merge(L[O], O) = C + merge(O, O) = CO
L[B] = B + merge(L[O], O) = B + merge(O, O) = BO
L[A] = A + merge(L[O], O) = A + merge(O, O) = AO

L[K2] = K2 + merge(L[C], L[A], CA)
      = K2 + merge(CO, AO, CA)
      = K2 + C + merge(O, AO, A)
      = K2 + C + A + mergeO, O)
      = K2CAO
同理
L[K2] = K1BAO

L[Z] = Z + merge(L[K2], L[K1], K2K1)
     = Z + merge(K2CAO, K1BAO, K2K1)
     = Z + K2 + merge(CAO, K1BAO, K1)
     = Z + K2 + C + merge(BO, K1BAO, K1)
     = Z + K2 + C + K1 + merge(BO, AO)
     = Z + K2 + C + K1 + B + merge(O, AO)
     = Z + K2 + C + K1 + B + A + merge(O, O)
     = Z + K2 + C + K1 + B + A + O
     = ZK2CK1BAO
L[Z] = ZK2CK1BAO
