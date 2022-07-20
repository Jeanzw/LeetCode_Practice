def kvSwitch(dic):
    new_dic = {}
    for k,v in dic.items(): #这里相当于是从原来的字典里面抽取key和value
        new_dic[v] = k #而后赋值给新的字典
    return new_dic