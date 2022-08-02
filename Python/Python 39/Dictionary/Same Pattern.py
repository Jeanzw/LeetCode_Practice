def SamePattern(a,b):
    a_dic = {}
    b_dic = {}
    if len(a) != len(b):
        return False
    else:
        for i in range(len(a)):
            # 这里如果是same pattern，那么如果当前字母是之前有的，那么index就应该是一样的，所以我们分别对a和b建立dic
            # 字母是key
            # index是value
            if a[i] in a_dic.keys() and b[i] in b_dic.keys():
                if a_dic[a[i]] != b_dic[b[i]]:
                    return False
            elif a[i] not in a_dic.keys() and b[i] not in b_dic.keys():
                a_dic[a[i]] = i
                b_dic[b[i]] = i
            else:
                return False
    return True   