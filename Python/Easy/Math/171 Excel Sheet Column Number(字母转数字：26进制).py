class Solution:
    def titleToNumber(self, s: str) -> int:
        m = dict()  #这里是相当于按照ASCII码来生成A-Z的字母表就不用自己一个个输入打成字母表了
        for i in range(26):
            m[chr(ord('A') + i)] = i + 1
        print(m)
        
        l = len(s)
        num = 0
        for i in range(l):
            num += m[s[i]] * 26**(l - i - 1)
            # 这里我们以AB为例，i = 0的时候，那么s[i] = A，那么我们在上面生成的字典中去找到A对应的数字也就是1
            # 接着我们要清楚这个算数的原理就是26进制，比如说是AB，那么对于A，这个位置的权重就是 2-1 = 1，也就是26的一次方，就是26
            # 而对于AB中的B，这个位置的权重是 2 - 2 = 0，也就是26的0次方，也就是0，然后把这两部分相加就是最后的数
        return num



#可以按照下面这样做，那么相当于是按照26进制的逻辑
res = 0
for i in range(len(s)):
    res = 26*res + m[s[i]]
print(res)
