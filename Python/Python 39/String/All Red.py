def AllRed(a):
    s = 0
    if a == []:
        return False
    for i in a:
        if 'red' in i:
            s += 1
    return s == len(a)