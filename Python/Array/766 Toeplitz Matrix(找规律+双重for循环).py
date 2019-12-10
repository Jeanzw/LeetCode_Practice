class Solution:
    def isToeplitzMatrix(self, matrix: List[List[int]]) -> bool:
        group = {}
        for col,row in enumerate(matrix):
            #print(col,row)
            for index,value in enumerate(row):
                #print(index,value)  
                #(0,0)和(1,1)和(2,2)要一样
                #(0,1)和(1,2)和(2,3)要一样
                #(1,0)和(2,1)要一样
                #(0,2)和(1,3)要一样
                #(2,0)要一样
                #(0,4)要一样
                
                #这里我们这样用减法的原因在于我们发现，其实坐标相减如果是一租的数应该是一样的
                if col-index not in group:
                    group[col-index] = value
                    
                elif group[col-index] != value:
                    return False
        return True


#思路2：直接去扫每一个元素，然后比较横纵坐标都+1时候的值是否和这个时候的值是一样的，如果是一样的，那么就是True
class Solution:
    def isToeplitzMatrix(self, matrix: List[List[int]]) -> bool:
                #(0,0)和(1,1)和(2,2)要一样
                #(0,1)和(1,2)和(2,3)要一样
                #(1,0)和(2,1)要一样
                #(0,2)和(1,3)要一样
                #(2,0)要一样
                #(0,4)要一样
                
                for i in range(len(matrix) - 1):  #len(matrix)算的是有多少行
                    for j in range(len(matrix[0]) - 1):   #len(matrix[0])算的是有多少列
                        if matrix[i][j] != matrix[i + 1][j + 1]:
                            return False
                
                return True