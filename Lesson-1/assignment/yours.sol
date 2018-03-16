/*作业请提交在这个目录下*/
/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary = 1 wei;
    address frank;
    address owner =0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunway() returns(uint){
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns(bool){
        return calculateRunway() > 0 ;
        
    }
    
    function  getPaid(){
        if(msg.sender != frank){
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        frank.transfer(salary);
    }
    
    function getSalary(uint x) returns(uint){
        if(msg.sender != owner){
             revert();
        }
        salary = x;
        return salary;
    }
    
    function getAddress(address x){
        if(msg.sender != owner){
            revert();
        }
        frank = x;
    }
    
}
