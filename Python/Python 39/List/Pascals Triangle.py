# leetcode 118
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        # 我们这里相当于是把大体框架给搭建起来，也就是确定了第一层的list里面有多少个小list
        # 以及每个小list里面有多少元素
        res = [[1] * i for i in range(1,numRows + 1)]
        # 接下来我们就是遍历每个小list里面的小元素，然后一一进行计算替换
        # 我们在第一个for循环里面其实是在第一层list里面遍历，去定位到小list
        # 因为第一、二行其实是属于特殊情况，那么我们其实不必更改对应的框架，具体需要计算改变的其实是从第三行开始
        # 所以我们这里是从index = 2开始
        for i in range(2,numRows):
            # 当我们确定list的位置后，那么就是要对具体list里面的元素进行改动
            # 我们从index = 1开始是因为，每一行其实第一个元素都是1，所以我们不需要对其进行改变
            # 而我们之所以选取stop index = i而不是i - 1是因为i其实是第一层的index，它本身就是比具体的真实行数少一，所以我们不需要再对其进行处理了
            for j in range(1,i):
                # 然后这个其实就是计算公式
                res[i][j] = res[i-1][j-1] + res[i-1][j]
        return res