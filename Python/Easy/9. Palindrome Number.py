class Solution:
    def isPalindrome(self, x: int) -> bool:
        x = str(x)
        if x == x[::-1]:
            return True
        else:
            return False



# 或者我们直接用reversed
# 但是要注意，reversed本身是打印不出来的，因为这个就是一个迭代器，但是如果我们将其放在list里面就可以打印出来了
class Solution:
    def isPalindrome(self, x: int) -> bool:
        x = str(x)
        return list(reversed(x)) == list(x)