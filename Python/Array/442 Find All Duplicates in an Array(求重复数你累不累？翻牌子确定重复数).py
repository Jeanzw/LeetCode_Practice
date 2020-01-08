l = [4,3,2,7,8,2,3,1]
coll = set()
duplicate = []
for i in l:
    if i not in coll:
        coll.add(i)
    else:
        duplicate.append(i)
print(duplicate)



#Gang的思路是：
#这一道题目的关键在于:
#题干说了，这是一串1 ≤ a[i] ≤ n，也就是说，正常来说就是1-n
#但是题干又说了要不然出现一次要不然出现两次，那么就意味着肯定有数字是没有出现的
#那么比如说我们有一组数
#                   【4   3   2   7   8   2   3   1】
#其对应的index应该是    0   1   2   3   4   5   6   7
#这个时候，第一个数字是4，那么其对应的index = 3的位置，那么我们将对应的value变成负数，表示已经出现了这么一个数了
#                   【4   3   2   -7   8   2   3   1】
#其对应的index应该是    0   1   2   3    4   5   6   7
#第二个数字是3，那么对应的是index = 2的位置，对应的value变成负数
#                   【4   3   -2   -7   8   2   3   1】
#其对应的index应该是    0   1    2   3    4   5   6   7
#第三个数字是2，对应的index = 1，将其对应的value变成负数
#                   【4   -3   -2   -7   8   2   3   1】
#其对应的index应该是    0    1    2   3    4   5   6   7
#第四个数字是7，对应的是index = 6的位置，对应的value变成负数
#                   【4   -3   -2   -7   8   2   -3   1】
#其对应的index应该是    0    1    2   3    4   5    6   7
#第五个数字是8，对应的是index = 7的位置，对应的value变成负数
#                   【4   -3   -2   -7   8   2   -3   -1】
#其对应的index应该是    0    1    2   3    4   5    6    7
#第六个数字是2，对应的index = 1的位置，但是我们发现这个位置的数字已经变成了负数，那么就说明早就有和他一样的数字占了这个坑，那么就说明这个是多出来的数字，抽出来
#同理第七个数字对应的是index = 2的位置，也为负数
#第八个数字是1，对应的index = 0的位置，对应的value变成负数
#                   【-4   -3   -2   -7   8   2   -3   -1】
#其对应的index应该是     0    1    2   3    4   5    6    7
class Solution:
    def findDuplicates(self, nums: List[int]) -> List[int]:
        res = []
        for i in range(len(nums)):
            #print(nums[i])
            if nums[abs(nums[i]) - 1] < 0:
                res.append(abs(nums[i]))
            else:
                nums[abs(nums[i]) - 1] = -nums[abs(nums[i]) - 1]
        return res
