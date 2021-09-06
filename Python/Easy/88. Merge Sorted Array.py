class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        for i in range(n):
            nums1[m + i] = nums2[i]
        
        return nums1.sort()



class Solution:
    def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        i,j = 0,0
        for j in range(n):
            while nums1[i] < nums2[j] and i < m + j:
                i += 1
            nums1.insert(i,nums2[j])
        nums1[:] = nums1[:m + n ]