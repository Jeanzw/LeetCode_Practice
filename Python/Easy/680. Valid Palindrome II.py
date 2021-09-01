class Solution:
    def validPalindrome(self, s: str) -> bool:
        start = 0 
        end = len(s) - 1
        while start <= end:
            if s[start] == s[end]:
                start += 1
                end -= 1
            else:
                return s[start:end] == s[start:end][::-1] or s[start + 1:end + 1] == s[start + 1:end + 1][::-1]
        return True



class Solution:
    def validPalindrome(self, s: str) -> bool:
        
        start = 0 
        end = len(s) - 1
        if s == s[::-1]: #首先判断是否可以直接颠来倒去，如果可以，直接输出True即可
            return True
# 如果不可以颠来倒去，就说明肯定要删除一个字母
        while start <= end:
            if s[start] != s[end]:  #如果两边字母不一样，那么说明要进入删除字母的时候了
                if s[start:end] == s[start:end][::-1] or s[start+1: end+1] == s[start+1: end+1][::-1]:  
                #这个if其实就是减去start所在的字母或者end所在的字母来看看是否可以颠来倒去
                # 如果可以，那么就是True
                    return True
                else:
                    # 如果不行，直接返回False
                    return False  
            # 如果start = end，那么就继续往里面推进
            start +=1
            end -=1
        return False