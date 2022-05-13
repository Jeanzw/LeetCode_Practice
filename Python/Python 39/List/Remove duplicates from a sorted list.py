def SortRm(a):
    s = set(a) #先转变为set，消除重复值
    return list(s) #而后将set转变为list


# 或者可以就是传统for循环确认重复值与否
def SortRm(a):
    l = []
    for i in a:
        if i not in l:
            l.append(i)
    return l