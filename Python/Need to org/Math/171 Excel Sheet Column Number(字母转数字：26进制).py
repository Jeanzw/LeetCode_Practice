s = 'ZY'
m = dict()  #这里是相当于按照ASCII码来生成A-Z的字母表就不用自己一个个输入打成字母表了
for i in range(26):
	m[chr(ord('A')+i)] = i+1
print(m)

n = len(s)
num = 0
for i in range(n):
    num += m[s[i]] * 26**(n - i - 1)
print(num)
    
#可以按照下面这样做，那么相当于是按照26进制的逻辑
res = 0
for i in range(len(s)):
    res = 26*res + m[s[i]]
print(res)
