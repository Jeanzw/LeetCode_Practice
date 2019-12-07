#https://www.pythonforbeginners.com/basics/list-comprehensions-in-python
#首先我们要来看看这个链接学会一下list comprehension，如何可以快速利用好if和for来得到我们想要的内容
class Solution:
    def imageSmoother(self, M: List[List[int]]) -> List[List[int]]:
        row = len(M)
        col = len(M[0])  #此处我们先计算出行列的数量，这样子之后我们就可以通过数字取进行定位了
        #由于我们如果直接在原array上进行修改必定会影响之后的📄，因为每一个位置的数进行计算的时候都会考虑原来围绕在他身边的八个数的情况
        #所以在这种情况，我们相当于建立一个和原array结构一样，但是全为0的array
        res = [[0]*col for i in range(row)]
        #print(res)   #这样就创建出了和原array结构一样的array了
        for i in range(row):
            for j in range(col):
                total_cell = 1  #这里我们是准备采用计数的方法来得到分母
                total_value = M[i][j]  #这里就是至少会计算当前格子的值，就是分母
                if i - 1 >= 0 and j - 1 >= 0:  #我们这里看的就是左上角的格子
                    total_cell += 1
                    total_value += M[i - 1][j - 1]
                if j - 1 >= 0:  #这里计算的就是左边的格子
                    total_cell += 1
                    total_value += M[i][j - 1]
                if i + 1 < row and j - 1 >=0:#这里计算的是左下角的格子
                    total_cell += 1
                    total_value += M[i + 1][j - 1]
                if i + 1 < row:  #这里计算的是下边的格子
                    total_cell += 1
                    total_value += M[i + 1][j]
                if i + 1 < row and j + 1 < col:  #这里计算的是右下角的格子
                    total_cell += 1
                    total_value += M[i + 1][j + 1]
                if j + 1 < col:  #这里计算的是右边的格子
                    total_cell += 1
                    total_value += M[i][j + 1]
                if i - 1 >= 0 and j + 1 < col:  #这里计算的是右上角的格子
                    total_cell += 1
                    total_value += M[i - 1][j + 1]
                if i - 1 >= 0:  #这里计算的是上边的格子
                    total_cell += 1
                    total_value += M[i - 1][j]
                res[i][j] = int(total_value/total_cell)   #对于取整：http://kuanghy.github.io/2016/09/07/python-trunc
        return res
