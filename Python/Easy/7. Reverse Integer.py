class Solution:
    def reverse(self, x: int) -> int:
        s = str(x)   #数字是不能直接s[0]操作的
        if s[0] == '-':
            x = - int(s[:0:-1])
        else:
            x = int(s[::-1])
        if x< -2 ** 31 or x> 2**31 - 1 or x ==0:
            return 0
        return x