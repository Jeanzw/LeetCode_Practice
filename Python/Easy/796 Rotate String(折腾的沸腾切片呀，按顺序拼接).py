A = 'abcde'
B = 'abced'

#思路1：直接进行字符串的拼接
class Solution:
    def rotateString(self, A: str, B: str) -> bool:
        for i in range(len(A)):
            behind = A[:i]
            after = A[i:]
            new_word = after + behind
            # print(new_word)
            if new_word == B:
                return True
        if A == B == '':
            return True
        else:
            return False



#思路2：我们把A给延长一倍，如果B在里面，那么就可以返回True
print(len(A) == len(B) and B in A + A)



#思路3：非常直接的方法
if len(A) != len(B):
    print(False)
if A == B == '':
    print(True)

#上面都是为了把特殊情况给列出来，接下来是重头戏了
move_char = ''  #我们给移动的内容装个表
index_B = 0    #相当于B的什么部分之后和diff_str进行拼接
for i in B:
    if (i ==A[0]):  #相当于从这个i开始后面就是A的内容了
        comp = (A == B[index_B:] + move_char)
        if (comp == True):
            print(True)
    move_char += i
    index_B += 1
print(False)