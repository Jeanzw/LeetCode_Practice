class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        loc = 0
        if len(nums) == 0:
            return 0
        elif len(nums) == 1:
            return 1
        for i in range(len(nums) - 1):
            if nums[loc] != nums[i + 1]:
                loc += 1
                nums[loc] = nums[i + 1]
        return loc + 1

# 我们如果用下面的方法，那么我们就可以直接处理[1]或者[]这样的情况了。
# 因为当只有1个元素或者为空集，根本就不可能进入for循环
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        loc = 1
        for i in range(1,len(nums)):
            if nums[i] != nums[i - 1]:
                nums[loc] = nums[i]
                loc += 1
        return loc