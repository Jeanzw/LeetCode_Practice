# 这道题目的思路其实很简单，就是实现F(N) = F(N - 1) + F(N - 2), for N > 1 这个公式
# 但是如果要在def里面实现这个公式，那么一定要用的就是self


class Solution:
    def fib(self, N: int) -> int:
        if N == 0:
            return 0
        if N == 1:
            return 1
        fibN_1 = self.fib(N - 1)
        fibN_2 = self.fib(N - 2)
        return fibN_1 + fibN_2