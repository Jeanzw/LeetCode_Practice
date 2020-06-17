# 此题思路：
# 我们就定下左右两边的index
# 算出water的常规公式
# 然后让左右两边的index都往里面移动


class Solution:
    def maxArea(self, height: List[int]) -> int:
        left, right = 0, len(height)-1
        water = 0
        while left < right:
            water = max(water, (right-left)*min(height[left], height[right]))
            if height[left]< height[right]:
                left +=1
            else:
                right-=1
        return water