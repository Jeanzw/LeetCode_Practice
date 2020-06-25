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




class Solution:
    def reverseVowels(self, s: str) -> str:
        s = list(s)
        v = 'aeiouAEIOU'
        l = 0
        r = len(s) - 1
        while l < r:
            if s[l] not in v:
                l += 1
            if s[r] not in v:
                r -= 1
            if s[l] in v and s[r] in v:
                s[l], s[r] = s[r], s[l]
                l+=1  #此处一定要在前后走一遭，不然就会陷入死循环了
                r-=1
        return "".join(s)