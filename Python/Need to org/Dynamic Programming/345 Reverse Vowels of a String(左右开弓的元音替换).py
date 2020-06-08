s = "leetcode"
vowels = ['a','e','i','o','u', 'A', 'E', 'I', 'O', 'U']
v = []  #我们相当于把原本的string里面的元音全部提取出来
for i in s:
    if i in vowels:
        v.append(i)
#print(v)

res = ''
pos = len(v) - 1  #我这里相当于是把string里面的最后一个字母的index给求出来
for j in s:  #for循环是从前往后扫，而我前面的pos是后往前扫
    #print(j)
    if j not in vowels:
        res += j
    else:
        res += v[pos]
        pos -= 1
print(res)





#Gang的思路，直接就是前后一起扫，用left和right来作为index
class Solution:
    def reverseVowels(self, s: str) -> str:
        vowel = 'aeiouAEIOU'
        i=0
        j=len(s)-1
        while i<j:
            while s[i] not in vowel and i<=j: #这里一定要写i<=j，不然i会继续扫，然后就会越界
                i += 1
            while s[j] not in vowel and i<=j:
                j -=1 
            if i<j:
                s[i], s[j] = s[j], s[i]
        return s