# 这一道题目的思路其实很清楚：
# 首先我们就是要reverse，而后我们需要的就是invert
# 对于reverse很简单，直接[::-1]可以搞定，但是要注意，我们需要重新开一个list来放reverse之后的内容
# 而对于invert，那么直接1变0，0变1，用if解决

class Solution:
    def flipAndInvertImage(self, A: List[List[int]]) -> List[List[int]]:
#         先将原本的array reverse
        reverse = []
        for i in A:
            i = i[::-1]
            reverse.append(i)
        print(reverse)
#         而后考虑invert
        row = len(reverse)
        col = len(reverse[0])
        for i in range(row):
            for j in range(col):
                if reverse[i][j] == 0:
                    reverse[i][j] = 1
                else:
                    reverse[i][j] = 0
        return reverse



#大神解法：利用^互异
A = [[1,1,0,0],[1,0,0,1],[0,1,1,1],[1,0,1,0]]
print([[1 ^ i for i in row[::-1]] for row in A])
#这里其实就是运用了python的^，我们先把A的第二层数组给抽出来，然后做一个颠倒
#如果二维数组里头的数和1互异，那么这个数一定是0，那么显示的互异结果就是1
#如果二维数组里头的数和1不互异，那么这个数一定是1，那么显示的互异结果就是0



#还可以直接用添加的形式
res = []
for line in A:
    res += [0 if val == 1 else 1 for val in line[::-1]],
print(res)



#还可以用abs()
print([[abs(1-i) for i in row[::-1]] for row in A])