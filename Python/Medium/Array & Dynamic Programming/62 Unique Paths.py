#思路1:
#直接当做一个数学问题，用阶乘来做
from math import factorial as f

class Solution(object):
    def uniquePaths(self, m, n):
        """
        :type m: int
        :type n: int
        :rtype: int
        """
        
        total = m + n - 2
        down = m - 1
        right = n - 1
        
        return f(total) / f(down) / f(right)



#思路2:
#问Gang，我看不懂
class Solution(object):
    def uniquePaths(self, m, n):
        """
        :type m: int
        :type n: int
        :rtype: int
        """
        table = [[0]*n for _ in range(m)]
        for i in range(n):
            table[0][i] = 1
        for j in range(m):
            table[j][0] = 1
        for i in range(1,m):
            for j in range(1,n):
                table[i][j] = table[i-1][j] + table[i][j-1]
        return table[m-1][n-1]


#下面是上面题目的解释，比如说我们一个m = 7 n = 3
start     ｜      1          ｜    1
1         ｜      1+1 = 2    ｜    2+1 = 3
1         ｜      1+2 = 3    ｜    3+3 = 6
1         ｜      1+3 = 4    ｜    4+6 = 10
1         ｜      1+4 = 5    ｜    5+10 = 15
1         ｜      1+5 = 6    ｜    6+15 = 21
1         ｜      1+6 = 7    ｜    7+21 = 28 end

#Gang的做法，先初始化一个全为1的列表，因为我们都是一步步走的
class Solution(object):
    def uniquePaths(self, m, n):
        """
        :type m: int
        :type n: int
        :rtype: int
        """
        dp = [[1] * n for i in range(m)]
        for i in range(1,m):  #我们之所以这里都是从1开始，是因为我们是不算start的时候的，我们永远都会走一步
            for j in range(1,n):
                dp[i][j] = dp[i-1][j] + dp[i][j-1]
        return dp[m-1][n-1] 
