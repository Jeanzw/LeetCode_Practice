def OddNums(i,j):
    l = []
    for i in range(i,j+1): #range(a,b) -> a -> b-1
        if i % 2 == 1:
            l.append(i)
    return l