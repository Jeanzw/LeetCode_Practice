list = [[1,1,0,0],[1,0,0,1],[0,1,1,1],[1,0,1,0]]
reverse_list = []
for i in list:
    reverse = i[::-1]
    reverse_list.append(reverse)
    #print(reverse)
#print(reverse_list)

invert_list = []
for i in reverse_list:
    invert = []  #这里相当于我先处理二维数组最里面的list的内容
    for j in i:
        #print(j)
        if j == 0:
            j = 1
            invert.append(j)
        else:
            j = 0
            invert.append(j)
    #print(invert)
    invert_list.append(invert)  #然后再把第二层list当做value一样添加到第一层list里面
print(invert_list)



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