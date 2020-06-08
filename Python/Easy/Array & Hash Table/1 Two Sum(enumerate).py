nums = [2, 7, 11, 15]
target = 9
residual = {}  #我们这里相当于是创建了一个dictionary
#这里的思路其实就是：
#当我们从nums这个列表中提取一个数字的时候，我们并不知道它的counter part是否存在
#那么在这个情况下，我们就先求出它对应的counter part（就是target - value)，而此时对应的index就是我们list里面的现在的index
#所以residual其实相当于是我们要的东西 we want
#这个字典里面装着的就是{the counter part we want:index now}
#之后如果我们发现nums里面的数字的确在we want这个字典里面，那么直接返回当前的index和之前的index，那么两个index对应的数之和就是我们的target
for i,n in enumerate(nums):  #对于enumerate()抽出的其实就是index以及value
    #print(i,n)
    if n in residual:
        print([i,residual[n]])
    else:
        residual[target - n] = i   
#print(residual)

#下面这样更好理解，
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        residual = {}
        for index,val in enumerate(nums):
            #print(index,val)
            if val not in residual:
                residual[target - val] = index
            else:
                return [index,residual[val]]


# 重做这道题目的时候，我的思路是这样的：
# 我们先一个个遍历这个list，然后用target去减去这个数得到余数，再遍历剩下的数，如果有等于余数的数存在，那么就是他了
# 因为题目说了，真相只有一个，所以我们不需要考虑多种情况了
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        for i in range(len(nums)):
            # print(nums[i])
            res_num = target - nums[i]
            # print(res_num)
            for j in range(i+1,len(nums)):
                if nums[j] == res_num:
                    return i,j