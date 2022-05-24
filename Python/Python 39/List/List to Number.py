def Lst2Num(l):
    length = len(l)
    res = 0
    for i in range(len(l)):
        if i == 0 and l[0] == 0:  #保证第一个数不是0，不然直接跳过
            continue
        else:
            res += l[i] * (10 ** (len(l) - 1 - i))
    return res