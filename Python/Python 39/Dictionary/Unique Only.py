def UniqueOnly(a):
    dic = {}
    for i in a:
        if i not in dic.keys():
            dic[i] = 1
        else:
            return False
    return True