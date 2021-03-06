#这一道题目其实是一道数学问题

#思路1：
#我们假设最开始array里面的数的总和为S，然后最小值是min，并且我们需要移动m次才能使得所有数相等
#每一次移动，都是对n-1个元素进行+1这样子的操作，我们假设最后所有的元素都是x
#那么我们可以得到的两个方程就是:
#1. S + (n - 1) * m = n * x
#2. min + m = x
#两个方程联立我们要求解m，那么m = S - n * min
list = [1,2,3]
m = sum(list) - len(list) * min(list)
print(m)



#思路2：
#最后代码和思路1是一样的
#逆向思维：其实n - 1个元素 +1相当于将所有元素都减小到最小的那个元素


#如果我们不用min()找到最小值，而是用sort找到最小值也是可以的
class Solution:
    def minMoves(self, nums: List[int]) -> int:
        nums.sort()
        # print(nums)
        res = 0
        for i in nums:
            res += i - nums[0] #这里其实我们用list.sort()已经将list里面的元素从小到大进行排序了
        return res





#思路3：最直接的方法，但是会超时
#最常用的思路就是最直接的方法
#每次都把数组进行排序，然后把前n - 1个元素+ 1，然后再进行排序，直到首尾元素相等即可