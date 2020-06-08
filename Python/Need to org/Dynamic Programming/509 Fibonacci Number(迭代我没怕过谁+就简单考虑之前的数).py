class Solution:
    def fib(self, N: int) -> int:
        if N == 0:
            return 0
        if N == 1:
            return 1
        fibN_1 = self.fib(N - 1)
        fibN_2 = self.fib(N - 2)
        return fibN_1 + fibN_2