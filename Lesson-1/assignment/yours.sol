/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {

    // 工资的领取时间周期10s
    uint constant payDuration = 10 seconds;
    // 合约地址
    address owner;
    // 工资
    uint salary;
    // 员工地址
    address employee;
    // 上个领薪日期
    uint lastPayday;
    // 构造函数设置合约地址
    function Payroll() {
        owner = msg.sender;
        salary = 1 ether;
    }
    //往合约设置工资
    function addFund() payable returns (uint) {
        return this.balance;
    }
    //计算合约的金钱能支付几个周期
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    //判断合约的余额能否支付一周期工资
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    //员工获取工资
    function getPaid() payable {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    //单独设置员工地址
    function setEmployeeAddress(address a) returns (address){
        require(msg.sender == owner);
        employee = a;
        return employee;
    }
    //单独设置员工工资
    function setEmployeeSalary(uint s) returns (uint){
        require(msg.sender == owner);
        salary = s * 1 ether;
        return salary;

    }
    //同时设置改员工地址和员工工资
    function updateEmployeeAndSalary(address e, uint s) payable {
        require(msg.sender == owner);
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }
    // 合同余额
    function getBalance() payable returns (uint){
        return this.balance;
    }
}
