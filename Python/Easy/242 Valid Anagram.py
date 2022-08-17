class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        from collections import Counter
        dic_s = Counter(s)
        dic_t = Counter(t)
        #print(dic_s)
        #print(dic_t)
        if dic_s == dic_t:
            return True
        else:
            return False  

# 也可以这样
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        t = sorted(t)
        s = sorted(s)
        return t == s