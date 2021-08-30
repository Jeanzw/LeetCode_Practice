# 下面这种做法和167. Two Sum II - Input array is sorted 原理是一样的
# 只不过因为这里我们需要求平方和，所以我们的end可以是从原来数的平方根开始往前推
# 同时这里没有说a != b，所以我们在while的时候需要用的是<=
class Solution:
    def judgeSquareSum(self, c: int) -> bool:
        start = 0
        end = int(math.sqrt(c))
        while start <= end:
            if start ** 2 + end ** 2 == c:
                return True
            elif start ** 2 + end ** 2 < c:
                start += 1
            else:
                end -= 1
        return False

# 原本我是想要和167一样也用字典来试一试的，但是问题是，这道题和167不一样的点在于167两个数是不能一样的，但是这道题两个数是可以一样的
# 所以如果我们用字典，这道题没法做