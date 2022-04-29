def RevLst(l):
    re_l = []
    for i in range(1,len(l) + 1):
        re_l.append(l[-i])
    return re_l


def RevLst(l):
    re_l = []
    for i in range(len(l)-1,-1,-1): 
        # 这里我们要注意是可以从后往前去列举的，但是要注意范围，最后一个数的index是len(l) - 1而不是len(l)，如果用后者那么就是超范围了
        # 同时我们的终点应该是-1而不是0，因为range的终点是取不到的
        re_l.append(l[i])
    return re_l