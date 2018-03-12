pragma solidity ^0.4.20;
contract Payroll{
    uint salary = 1 ether; //以eth做为薪水
    address frank = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration= 20 seconds;
    uint lastPayday = now;
	
    //作业：更新员工地址与薪水
    function updateAdressAndSalary(address newAddress,uint newSalary) public{
        
        // 先把欠款的支付完
        if(frank!=0x0){
            uint leftsalary = (now-lastPayday)/payDuration*salary;
            frank.transfer(leftsalary);
        }
        frank=newAddress;
        salary=newSalary* 1 ether;
    }
	
    //扩展方法-获取还有几次未付款
    function getCount() public returns(uint){
        return (now-lastPayday)/payDuration*salary;
    }
 
    //给合约增加金额
    function addFund() payable returns(uint){
        return this.balance;
    }
	
	//可以支付薪水的次数
    function calculateRunway() returns(uint){
        return this.balance/salary;
    }
	
	//是否可以足够支付
    function hasEnoughFund() returns(bool){
        return calculateRunway()>0;
    }
	
	//领取薪水
    function getPaid(){
        if(lastPayday+payDuration>now){
            revert();
        }
        lastPayday=lastPayday+payDuration;
        frank.transfer(salary);
    }
	//扩展方法-查看员工的余额
    function getFrankFund() returns (uint){
        return frank.balance;
    }
    //扩展方法-查看合约的余额
    function getThisFund() returns (uint){
        return this.balance;
    }
}
