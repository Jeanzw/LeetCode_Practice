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