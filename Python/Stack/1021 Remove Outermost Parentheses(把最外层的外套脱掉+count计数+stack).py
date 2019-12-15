class Solution:
    def removeOuterParentheses(self, S: str) -> str:
        index = [-1]
        cnt = 0
        res = ''
        for i in range(len(S)):
            if S[i] == '(':
                cnt += 1
            else:
                cnt -= 1
            if cnt == 0:
                index.append(i)
        print(index)
        
        for j in range(len(index) - 1):
            res += S[index[j]+2:index[j+1]]
        
        return res


#思路2:
#用opened来进行判断，opened > 0至少是保证了(符号至少是第二个，也就是最外头的已经去掉了
#而对于右括号的opened > 1其实也保证了这个右括号是在最外层的里头
class Solution:
    def removeOuterParentheses(self, S):
        res, opened = [], 0
        for c in S:
            if c == '(' and opened > 0: res.append(c)
            if c == ')' and opened > 1: res.append(c)
            opened += 1 if c == '(' else -1
        return "".join(res)



#思路3:
#相当于我们先把所有的内容都弄到element这里
#一旦发现左右括号数量一致，那么我们就要开始动手从element里面抽取了，抽取的内容就是第二个和倒数第二个
class Solution:
	def removeOuterParentheses(self, S: str) -> str:
        count = 0
        element = ""
        result = ""
        
        for c in S:
            element += c
            if c == "(":
                count += 1
            elif c == ")":
                count -= 1

            if count == 0:
                result += element[1:-1]
                element = ""

        return result


#思路4:stack
#例子(()())
def removeOuterParentheses(self, S: str) -> str:
        end = len(S)-1  #最后的index
        index = 0
        stack = []
        res = ""
        while index <= end:
            if S[index] == '(':
                stack.append(index)
            elif S[index] == ')':
                start = stack.pop()  #只有遇到右括号的时候，才会pop stack，并且要注意，这里stack里面储存的是左括号的index
            if not stack:
                res = res + S[start+1:index]
            index += 1     
        return res