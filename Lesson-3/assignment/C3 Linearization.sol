contract O
contract A is O
contract B is O
contract C is O
contract K1 is A, B
contract K2 is A, C
contract Z is K1, K2

https://en.wikipedia.org/wiki/C3_linearization
https://blog.tedxiong.com/C3_Linearization.html

L[O] = [O]
L[A] = [A,O]
L[B] = [B,O]
L[C] = [C,0]
L[k1] = [K1]+merge(L[A],L[B],[A,B])  // merge规则：按照继承顺序加入父类，最后是一个所有父类添加顺序的序列
      = [K1]+merge([A,O],[B,O],[A,B]) // 规则：取一个元素（它是其他序列中的第一个元素，或不在其他序列出现,如果有多个元素符合，选前面一个）加到最前序列后面
      = [K1,A]+merge([O],[B,O],[B])
      = [K1,A,B,O]
L[K2] = [k2,A,C,O]
L[Z]  = [Z] + merge(L[K1],L[K2],[K1,K2])
      = [Z] + merge([K1,A,B,O],[k2,A,C,O],[K1,K2])
      = [Z,K1,K2,A,B,C,O]
