
# 这里我们先讲几个会导致错误的例子：
# 1. [[1,1,1],[1,1,0],[0,0,1]] -> 这个结果应该是-1，因为虽然第三个人是谁都不认识，但是第二个人并不认识他，并不满足所有人都认识他的条件
# 2. [[1,0],[1,1]] -> 结果应该是0
# 3. [[1,0],[0,1]] ->这个结果应该是-1，因为两个人都只认识自己不认识别人

class Solution(object):
    def findCelebrity(self, n):
        """
        :type n: int
        :rtype: int
        """
        # 整个过程中我们使用三个for循环
        candidate = 0
        for i in range(1, n):
            if knows(candidate, i):
                candidate = i
        # 第一个for循环我们找出可能的candidate，也就是我们找出一个人，他除了自己，谁都不认识
        # 一旦我们发现某人认识别人任何一个人，那么他就肯定不是celebrity，那么我们就要转移目标
        # 这里我最开始的一个疑惑就是，如果在candidate = 0 的时候，但是下一个candidate是10，那么我们怎么保证1-9都不是潜在的celebrity呢？
        # 我们可以这么想，如果继candidate = 0之后的下一个candidate = 10
        # 那么knows(0, 1)到knows(0, 9)肯定都不成立，如果1-9有一个潜在celebrity，那么不存在candidate = 0的情况不认识他，因为题目中说了，所有人都认识celebrity
        
        # 所以我们可以直接取：找到不认识所有人的那个candidate他可能会是celebrity
        # 但是我们不确定，因为上面这个for可能不满足最开始我们提出的3个错误例子
        # 所以接下来，我们需要对这个candidate进行确认

        for i in range(n):
            if i != candidate and knows(candidate, i):
                return -1
        # 这个for循环中，我们重新开始扫所有人，确保第一个for循环找出来的candidate其实不认识任何别的人
        
        for i in range(n):
            if i != candidate and not knows(i, candidate):
                return -1
        # 最后一个for循环，我们依旧扫所有人，确保所有人都认识第一个for循环找出来的candidate

        # 我们后面两个for循环，其实是帮我们确认一遍：
        # 1.celebrity不认识别的人
        # 2.别的人都认识celebrity这个条件
        return candidate
        
            