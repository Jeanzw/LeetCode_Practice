class Solution:
    def climbStairs(self, n: int) -> int:
        #2 -> 2
        #3 -> 3
        #4 -> 5
        #5 -> 8
        #6 -> 13
        if n == 1:
            return 1
        if n == 2:
            return 2
        clibm_n_1 = self.climbStairs(n - 1)
        clibm_n_2 = self.climbStairs(n - 2)
        return clibm_n_1 + clibm_n_2

        #上面的代码逻辑没有问题，只是会超时
#问gang：为什么下面的这种方法不会超时，而我的方法会超时？
#回答：比如我们在算4的时候要算3和2，当我们算3的时候又要算2和1，这里有多次重复的无用功
class Solution:
    def __init__(self):
        self.stairTable = {1:1, 2:2}
    def climbStairs(self, n):
        # s(n) = s(n-1) + s(n-2)
        if n not in self.stairTable:
            self.stairTable[n] = self.climbStairs(n-1) + self.climbStairs(n-2)
        return self.stairTable[n]


#另外的想法就是相当于动态做一个数字替换
class Solution:
    def climbStairs(self, n):
        if n == 1:
            return 1
        if n == 2:
            return 2
        x1 = 1
        x2 = 2
        for i in range(3,n+1):
            x3 = x1 + x2
            x1 = x2
            x2 = x3
        return x3


#还有一种想法就是说，我们可以把小于n的所有数可以有的组合数的都加进一个list里面，然后最后取最后一个就好了
class Solution:
    def climbStairs(self, n):
        if n == 1:
            return 1
        res = [1,2]
        for i in range(2, n):
            ans = res[i-1] + res[i-2]
            res.append(ans)
        return res[-1]