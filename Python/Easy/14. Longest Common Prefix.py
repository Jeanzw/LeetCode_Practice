class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        strs = sorted(strs,key = len) #这个function是要记住的
        start = strs[0]
        for i in range(len(start)):
            for j in range(1, len(strs)):                    
                if strs[j][i] != start[i]:
                    return start[:i]
        return start

# 这道题的步骤是：
# 1. 先把所有的string给排个序 -> 因为如果不排序，比如flower， flow 那么当我们扫第一个flower到er的时候，flow其实没东西可扫了，那么这个for循环就会出问题
# 2. 我们需要做一个定位。我们既然要找前缀string一致，那么我们拿其中一个出来作为标杆，然后让剩下的string与之相同即可
# 3. 两个for循环药考虑到底先扫哪个后扫哪个
#     在这里，因为我们要保证前缀一致，那么就需要用第一个string 作为标杆来扫
#     先扫第一个字母，然后去扫第二个string的第一个字母看是否一致，再去扫第三个string的第一个字母
#     如果所有string的第一个字母都一致，那么我们就继续扫第二个字母
#     重复上述步骤
# 4. 但是如果我们发现扫到哪个字母的时候，后续的string是没有在对应的index里面扫到相同的字母，就应该停止for循环，也就是说我们相同的前缀已经到此结束了