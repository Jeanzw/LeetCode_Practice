def FibLst(n):
    if n < 1:
        return -1
    elif n == 1:
        return [0]
    elif n == 2:
        return [0,1]
    else:
        l = [0,1]
        for i in range(2,n):
            l.append(l[i - 1] + l[i - 2])
        return l
