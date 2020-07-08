# 此题的思路就是：
# 我们先把每个字母最后一次出现的index给找出来
# 然后当我们扫S的时候，判断所处的字母是否是最后一个字母出现的index
# 如果是，那么就放到list里面

class Solution:
    def partitionLabels(self, S: str) -> List[int]:
        last = {c: i for i, c in enumerate(S)}  #这里其实我们就是把所有字母的最后一个出现的index给弄出来，因为弄出了字典的形式，所以就可以避免重复的情况了，抽出来的肯定是最后一个出现的位置
        #print(last)
        j = anchor = 0  #此处初始化j和anchor，j是用来当作后坐标，而anchor是用来当作前坐标
        res = []
        for i, c in enumerate(S):
            #print(i,c)
            j = max(j,last[c])  #这一步其实就是保证了其实我在刷S的过程中，j会选择最长的内容
            if i == j:
                res.append( i - anchor + 1)
                anchor = i + 1
        
        return res
    
#tip:其实在创建last的过程，相当于是：
#        dic = {}
        #for i, char in enumerate(S):
         #   dic[char] = i