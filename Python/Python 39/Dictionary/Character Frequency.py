def ChaFreq(a):
    dic = {}
    for i in a:
        if i not in dic.keys():  
            # dic.keys() -> 将字典的key抽出来，形成一个list
            # dic.values() -> 将字典的values抽出来，形成一个list
            dic[i] = 1
        else:
            dic[i] += 1
    return dic