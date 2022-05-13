def NumInsert(a,b):
    for i in range(len(a)):
        if a[-1] <= b:  #这个考虑的是这种情况：NumInsert([1, 2, 3, 4, 5, 6], 7) returns [1, 2, 3, 4, 5, 6, 7]
            index = len(a)
        if a[i] > b:
            # 这个考虑的是这两种情况：
            #   1. NumInsert([1, 2, 3, 4, 5, 6], 3) returns [1, 2, 3, 3, 4, 5, 6]
            #   2. NumInsert([1, 2, 3, 4, 5, 6], -1) returns [-1, 1, 2, 3, 4, 5, 6]
            index = i
            break
    return a[:index] + [b] + a[index:]  #这里相当于是一个拼接了
    # 当list中没有一个数小于所给数，那么index = 0， a[:0] 相当于什么都没有
    # 当list中没有一个数大于所给数，那么则是第一个if，index相当于是这个list的长度，那么a[:index]相当于把原列表直接拿过来，然后拼接上所给数


    