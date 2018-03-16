pragma solidity ^0.4.20;
contract Payroll{
    uint salary = 1 ether; //以eth做为薪水
    //员工地址
    address frank = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration= 20 seconds;
    uint lastPayday = now;
	
	 //更新员工地址
    function updateAdress(address newAddress) public{
        
        // 先把欠款的支付完
        if(!payHistorySalary()){
		      revert();
		    }
        frank=newAddress;
    }
    
    //更新员工薪水
    function updateSalary(uint newSalary) public{
        
         // 先把欠款的支付完
         if(!payHistorySalary()){
		        revert();
		      }
        salary=newSalary* 1 ether;
    }
    //每次都都需要把历史薪水支付完
    function payHistorySalary() returns(bool){
        
        // 先把欠款的支付完
        if(frank!=0x0){
            uint mustPaySalary = (now-lastPayday)/payDuration*salary;
			      uint leftSalary=this.balance-mustPaySalary;
            if(leftSalary>=0){
				        //支付全部拖欠的
                frank.transfer(mustPaySalary);
                lastPayday = now;
				        return true;
            }
            else{
                //合约薪水不够支付			
              return false;
            }
        }
        //如果员工账户为空 默认为true
		    return true;
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
	
	//到时间就领取薪水
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
