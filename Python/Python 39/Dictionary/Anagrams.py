def anagrams(a,b):
    a_dic = {}
    b_dic = {}
    if len(a) != len(b):
        return False
    else:
        for i in range(len(a)):
            if a[i] in a_dic and b[i] in b_dic:
                if a_dic[a[i]] != b_dic[b[i]]:
                    return False
            elif a[i] not in a_dic and b[i] not in b_dic:
                a_dic[a[i]] = i
                b_dic[b[i]] = len(b) - 1 - i
            else:
                return False
    return True