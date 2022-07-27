def RankK(a):
    # dic sort 11 ways: https://pythonguides.com/python-dictionary-sort/
    sort_values = sorted(a.items(), key = lambda y:y[1]) #将dic按照value进行排序
    # 得到的结果是sort values: [('b', 5), ('a', 7), ('c', 9)]
# 而后我们就可以按照双重list的取数方法进行操作了
    res = []
    for i in range(len(sort_values)):
        print(i)
        res.append(sort_values[i][0])
        print(sort_values[i][0])
    return res