#思路1:直接遍历所有值，没有任何技巧
class Solution:
    def licenseKeyFormatting(self, S: str, K: int) -> str:
        ans = ''
        cnt = 0
        S = ''.join(S.split('-')).upper()  #将所有的-都去掉
        print(S)
        for i in S[::-1]:  #我们逆着数个数
            ans += i
            cnt += 1  #数多少字符
            if cnt % K == 0 and ans:  #当确保字符串不是空，并且我们数的字符已经是等于K的时候，就可以加入-
                ans += '-'
        
        if ans and ans[-1] == '-': #我们这里相当于做了一个判断，也就是如果最后一个是‘-’那么如何办，如果不是那么又如何处理
            return ans[-2::-1]
        else:
            return ans[::-1]


#思路2:用insert
class Solution(object):
    def licenseKeyFormatting(self, S, K):
        """
        :type S: str
        :type K: int
        :rtype: str
        """
        if len(S) < 1: return ""
        l = []
        for v in S:  #此处的for相当于是要把-给去掉，然后把所有的字母都变成大写
                if v == '-':
                        continue
                l.append(v.upper())
        idx = len(l)
        while(idx > K): 
                l.insert(idx-K, '-')  #用idx - K来作为index，用insert来进行定位
                idx = idx-K

        return "".join(l)



# 思路3:依旧利用index来解题
class Solution(object):
    def licenseKeyFormatting(self, S, K):
        """
        :type S: str
        :type K: int
        :rtype: str
        """
        s = ''.join(S.split('-'))
        n = len(s)
        count = n//K   #求整，然后直到最多需要插入几个-
        for i in range(1,count + 1):   #之所以从1开始来算，是因为我们不可能在最末端弄一个-，至少也会往前走K歌
            pos = n - i * K
            if pos > 0:   #这部分保证-符号不会加到最前面
                s = s[:pos] + '-' +s[pos:]  #由于pos是从后往前走的，所以就算这里的s进行变动仍旧不会影响，因为前面的部分不变，那么index这样走下来是没有问题的
        return s.upper()