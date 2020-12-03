"""
我们拿题目给的例子举例
[1],
[1,1],
[1,2,1],
[1,3,3,1],
[1,4,6,4,1]

我们假设讨论第三行的第二个数字，其对应的row = 2， col = 1
如果我们要求它，那么我们直接需要的就是将row = 1 col = 0和row = 1 col = 1的相加即可
那么在这个逻辑中，其实关系就已经确定了

"""

class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        if numRows == 0:
            return []  #我们先讨论最特殊的情况，就是给的numRows = 0，那么返回的就肯定是一个空列表
        res = [[1]]  #如果numRows > 0，那么我们敢保证的就是一定返回至少一个[[1]]，所以我们的初始值设定为这个
        for i in range(1, numRows):  #由于我们初始值的条件是我们假定numRows > 0，而在numRows = 1的情况我们已经设定为初始值，所以如果扫行，怎么都会从row = 1开始扫
            # 这里的i相当于代表行数
            t = [1] #由于每一行都是从1开始，所以我们这里先设定一个1
            # 1, 2, 3
            for j in range(1, i+1):  
                # j代表的是列数
                #由于行和列是一样的数字，所以我们直接取i所在的行数当作列
                # 因为range（）是不取后者的，所以我们在这里用i + 1
                t.append(res[i-1][j-1])   #我们可以保证[i-1][j-1]是一定存在的，所以我们先加进去
                        #  但是因为我们没办法确定[i-1][j]是一定存在的，所以这个时候我们需要用一个if来进行讨论
                if j < len(res[i-1]): #当i行中的列数是有上面一行与之对齐的，那么我们可以确定[i-1][j]是一定存在的，否则就不存在，那么直接取上面一行的最后一个数，也就是1
                    t[-1] += res[i-1][j]
            res.append(t)
        return res

#  另外一种做法，其实和上面原理一样
# 只不过在选择j列的时候，上面的做法是一起讨论
# 而下面的做法是我最后一个数字因为永远是1， 那么我最后加上1就好了
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        if numRows == 0:
            return []
        res = [[1]]
        for i in range(1, numRows):
            t = [1]
            # 1, 2, 3
            for j in range(1, len(res[i-1])):
                t.append(res[i-1][j-1] + res[i-1][j])                    
            res.append(t + [1])
        return res