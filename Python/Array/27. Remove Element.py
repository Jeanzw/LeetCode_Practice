# 题目中说了：
# Do not allocate extra space for another array, you must do this by modifying the input array in-place with O(1) extra memory.
# 那么我们只可以改原来的内容，相当于用如果一样，那么就继续扫，如果不一样那么就替代之前的内容
# 然后得到长度，输出这个长度就好

class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        point = 0
        for i in nums:
            if i != val:
                nums[point] = i
                point += 1
        return point


# 下面的这种方法就是直接用remove这个操作
class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        while val in nums:
            nums.remove(val)