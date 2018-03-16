## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

### 回答：
加入员工时，calculateRunway这个函数gas变化如下：

 transaction cost,  execution cost 
 22966 1694
 23747 2475
 23528 3256
 25309 4037
 26090 4818
 26871 5599
 27652 6380
 28433 7161
 29214 7942
 29995 8723
 
 可以看到，在calculateRunway函数中，因为employees数组的长度不断增大，遍历这个数组所需要的gas也不断增大，所以需要把计算salary放在别的地方。
 
 
