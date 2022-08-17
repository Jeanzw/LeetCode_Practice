A = [[1,2,3],[4,5,6],[7,8,9]]
#https://snakify.org/en/lessons/two_dimensional_lists_arrays/
#print(A[0][0])
R = len(A)     #如此知道有多少列
C = len(A[0])  #如此知道新的矩阵中有多少元素，即有多少行
transpose = []
for c in range(C):
    # 我们之所以在先扫列再扫行，那是因为我们其实是对于列一行行扫，然后使其变成行的然后存储到new_Row里面的
    # 因为我们是以row为单位存储的，所以必须先扫列，再存储到行里面
    newRow = []
    for r in range(R):
        newRow.append(A[r][c])
    transpose.append(newRow)  #这里相当于是说，我先创建一个list，然后再把这个list加入到另一个list里面
print(transpose)


#另一种方式直接用np
import numpy as np
print(np.transpose(A))
print(np.array(A).T)  #如果直接用T那么需要是array

#另一种方式直接用zip
print(list(zip(*A)))