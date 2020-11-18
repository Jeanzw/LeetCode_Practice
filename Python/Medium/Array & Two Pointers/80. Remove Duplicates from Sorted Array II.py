# 我写的内容
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        if len(nums) == 0:
            return 0
        cnt = 1
        point = 0
        for i in range(len(nums) - 1):
            if nums[i + 1] == nums[i]:
                cnt += 1
                if cnt <= 2:
                    nums[point] = nums[i]
                    point += 1
                # else:
                #     cnt = 1
            else:
                cnt = 1
                # 在这里我们是选择，当前后数字不一样的时候，我们才开始重新计数
                # 之前我们是把cnt重新设为1的步骤放到了上面，这么是错的，错误理由是：我们这么想，如果我们有 1 1 1 1
                # 那么当我们计数到第三个1的时候，已经满足了cnt > 2，那么清零，那么我们看到第四个1的时候，又回认为只有1个1，所以那个时候清零是错的
                # 所以我们只有在前后数字不一样的时候才开始重新让cnt恢复到原来的样子
                nums[point] = nums[i]
                point += 1
            print("i: ",i, "cnt: ", cnt, "point: ", point)
            print(nums)
        nums[point] = nums[-1]
        return point + 1
    
"""
i = 0
nums[1] == nums[0]
cnt = 1
nums[0] = 1
point = 1

i = 1
nums[2] == nums[1]
cnt = 2
cnt = 0

i = 2
nums[]

"""



# 下面是gang的解法
class Solution(object):
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        cnt = 1
        start = 1
        for i in range(1, len(nums)):
            if nums[i] == nums[i-1]:
                cnt +=1
                if cnt <= 2:
                    nums[start] = nums[i]
                    start +=1
            else:
                cnt = 1
                nums[start] = nums[i]
                start +=1
        
        return start
                
                