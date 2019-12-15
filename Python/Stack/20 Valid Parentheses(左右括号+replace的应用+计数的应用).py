s = "()"


#思路1：
#我们相当于是在做减法，一旦发现有正规的这种存在那么就将其从原来的s中剔除，那么最后如果提出到是空的，那么就是对的
while "()" in s or "{}" in s or '[]' in s:
    s = s.replace("()", "").replace('{}', "").replace('[]', "")
print( s == '')  #这样的方法就算str是"{[]}"也没有关系，先处理里面的[]，然后再处理外头的{}


#思路2：
#我们相当于是在计数，如果是左括号那么就是+1，如果是右括号那么就是-1，看最后是否为0，如果是0那么返回True
#我们拿最简单的()来做例子
#（    ）
# +1  -1
def valid(self, s):
cnt = 0
for c in s:
	if c == '(':
		cnt +=1
	elif c == ')':
		cnt -=1
	if cnt < 0:  #这一步相当于是保证顺序的，也就是不能为负数
		return False
return cnt == 0


#思路3：
#我利用stack
def isValid(self, s):
                         #012   012   #此处的012就是在这个string里面，三种括号对应的index
    left, right, stack= "({[", ")}]", []
    for item in s: #这里已经保证了s不是空字符串"",因为如果是空，那么就不能循环了，直接跳到最后的return，返回一个True
        if item in left:  #如果是左括号的，那么就抽出来加入到这个空列表中
            stack.append(item)
        else:#如果不是左括号，那么就是右括号了
            #那么有两种情况：
            #1. stack如果是空的话，那么就返回False，因为相当于这个右括号之前没有左括号做对应
            #2. 就算这个stack不是空，那么我们来讨论顺序问题，我们要让发现的第一个右括号就是stack列表的最后一个value
                           #为了保证这是对应的，其实我们只需要让左右括号的index是一致的就可以了
            if not stack or left.find(stack.pop()) != right.find(item):
                return False
    return not stack  #如果列表是空，那么直接跳到这一步，stack是空列表，那么就是False，但是not stack就是True了


#同样的思路来将上面的方法做一个变形：
dict = {
"]":"[", 
"}":"{", 
")":"("
}  #这个字典其实就相当于我们上面的左右列表
        for char in s:
            if char in dict.values():
                stack.append(char)
            elif char in dict.keys():
                if stack == [] or dict[char] != stack.pop():
                    return False
            else:
                return False
        return stack == []
