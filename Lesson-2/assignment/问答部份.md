第二课问答部份
======================

##第2题，每次加入一个员工后调用calculateRunway这个函数,并且记录消耗的gas

address	                                 transaction cose	execution cost
--------------------------------------------------------------------------
0x14723a09acff6d2a60dcdf7aa4aff308fddc160c  22,958	1,686<br>
0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db	23739	2467<br>
0x583031d1113ad414f02576bd6afabfb302140225	24520	3248<br>
0xdd870fa1b7c4700f2bd7f44238821c26f7392148	25301	4029<br>
0xcd7940eb22180727a5654c79a95caddc23fd3a6c	26082	4810<br>
0x1f8215c3b57eff7e493f3250a850258cf307435f	26863	5591<br>
0x5432ae101536f50ef6b34d5e4e43475fae8dc4e4	27644	6372<br>
0x124d7a36297098b987fbab8d8862e6dc601f3bcb	28425	7153<br>
0x73d195e4307bac55010ee1d20238e595546dce5c	29206	7934<br>
0xd054a440bb0ad1c7c813dc6919e07766fede1086	29987	8715<br>

##第3题：Gas变化么？如果有，为什么？<br>
    gas每次调用都会变化，每次调用比上一次多781，原因是 全局变量 employees的成员越来越多，程序使用了for循环语句，所以执行成本就会越来越高。

##第4题：如何优化calculateRunway函数来减少gas的消耗?<br>
    为了让calculateRunway函数保持一定的gas，我在合约中设置了一个状态变量salarysum，用来保存总工资，
    在新增员工，删除员工，修改员工工资时都更新一次salarysum的值。这样在calculateRunway函数中不需要fot循环，大大减少合约的执行成本。
    修改后的calculateRunway函数，gas消耗固定在 22146+874这个值。

