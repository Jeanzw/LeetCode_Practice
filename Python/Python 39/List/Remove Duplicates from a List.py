def RmDuplicate(a):
    l = []
    for i in a:
        if i not in l:
            l.append(i)
    return sorted(l)