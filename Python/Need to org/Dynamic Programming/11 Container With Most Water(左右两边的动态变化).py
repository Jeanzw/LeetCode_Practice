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