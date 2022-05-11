def SepNum(a):
    l = []
    for i in a:
        if i % 2 == 0:
            l.append(i)
    for j in a:
        if j not in l:
            l.append(j)
    return l