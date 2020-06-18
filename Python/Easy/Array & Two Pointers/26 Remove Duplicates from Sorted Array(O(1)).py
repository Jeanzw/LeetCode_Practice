class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        s = set(nums)
        #print(s)
        l = list(s)
        print(l)
        return len(l)  #我不懂啊……为什么这个就是说我出错了，我如果直接return l
        #为什么就是要一步步来计数……

#我的做法是错误的，Gang跟我说，题目中一个in—place和do not allocate extra space for another array
#这个的意思就是，就在原来的list上进行修改，而我上面无论是用set还是用list都是创建了一个新的空间来储存我们的内容
#所以这道题整体的思路应该如下：
[0,0,1,1,1,2,2,3,3,4]
i=0  0    j=1  0
i=0  0    j=2  1  #这个时候就不是重复的内容，所以i可以往前走一个格子，然后将i + 1这一位给替换掉新的不重复的数字，然后j继续往后扫
i = i+1 = 1    nums[i] = nums[j] = 1    j=3
[0,1,1,1,1,2,2,3,3,4]
   i     j

i=1  1     j=3  1
i=1  1     j=4  1
i=1  1     j=5  2
i = i+1 = 2   nums[i] = nums[j] = 2  j= 6
[0,1,2,1,1,2,2,3,3,4]
     i       j  

i=2  2     j=6  2
i=2  2     j=7  3
i = i+1 = 3   nums[i] = nums[j] = 3   j=8
[0,1,2,3,1,2,2,3,3,4]
       i         j

i=3  3     j=8  3
i=3  3    j=9  4
i = i+1 = 4    nums[i] = nums[j]  = 4   j=10

[0,1,2,3,4,2,2,3,3,4]
         i            j  #在此结束


class Solution:
    def removeDuplicates(self, nums):
        if not nums: return 0
        cur, length = 1, len(nums)
        for i in range(1, length):
            if nums[cur-1] != nums[i]:
                nums[cur], cur = nums[i], cur + 1
        return cur
