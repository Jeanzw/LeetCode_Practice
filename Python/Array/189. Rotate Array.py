class Solution(object):
    def rotate(self, nums, k):
        k = k % len(nums)
        nums[:] = nums[-k:] + nums[:-k]
        # 我们这里之所以用k % len(nums)，是因为我们要考虑可能k是比len(nums)要大的，一旦k和len(nums)一样大，那么就相当于和原来是一样的了


# 另一种做法就是用insert
# https://www.programiz.com/python-programming/methods/list/insert
# list.insert(i, elem)
# If i is 0, the element is inserted at the beginning of the list.
# 而其中还包括pop：https://www.programiz.com/python-programming/methods/list/pop
# 其中pop相当于把列表中最后一个元素给嘣出来，然后利用insert放到列表的第一个
class Solution(object):
    def rotate(self, nums, k):
        for i in range(k % len(nums)):
            nums.insert(0, nums.pop())



# 另外一种做法就是我们新建一个list，对其进行处理，最后将其copy给原list
# Use an additional array to copy the elements into rotated positions and copy them back to original array
class Solution(object):
    def rotate(self, nums, k):
        k = k % len(nums)
        dupnums = [0] * len(nums)
        for i in range(len(nums)):
            dupnums[(i + k) % len(nums)] = nums[i]

        nums[:] = dupnums # copy dupnums to nums