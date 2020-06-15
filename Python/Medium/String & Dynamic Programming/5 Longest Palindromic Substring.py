# 此题的思路其实很简单：
# 我们先从整体开始一个个元素往后扫，设为i
# 然后每一轮继续顺着i + 1 往后扫设为j，知道扫到和自己一样的元素
# 然后把[i:j + 1] 取出来，判断是否是paalindromic substring，判断方式就是[::-1]是否和原本的一致
# 如果一致，那么替换掉原本的res，如果不是那么继续扫


class Solution:
    def longestPalindrome(self, s: str) -> str:
        if len(s) == 0:
            return ""
        res = s[0]
        for i in range(len(s)):
            for j in range(i+1,len(s)):
                #print(s[i],s[j])
                if s[i] == s[j]:
                    a = s[i:j+1]
                    if a[::-1] == a:
                        if len(res) < len(a):
                            res = a
                            
        return res


#我这里的想法其实就是，我们一个个开始扫，然后穷举法，如果是回文字符，那么颠倒也应该是满足条件的，所以我们用一个切片法a[::-1] == a
#另外，之所以我们需要最开始的if是因为，我们可能会遇到“”空字符串的时候
#而我们之所以最开始要用res = s[0]是因为，如果我们输入的是“ab”，没有任何回文字符的时候，那么系统默认单个字符也算回文字符，所以我们需要先设定其存在
