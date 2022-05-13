def MergeSorted(a,b):
    l = [a + b]
    return sorted(l)




def MergeSorted(a,b):
    l = []
    i,j = 0,0 #这里相当于给了两个列表两个指针
    while i < len(a) and j < len(b):
        # 注意这里需要用and而不是or，因为我们要保证二者都是在list里面的
        if a[i] < b[j]:
            l.append(a[i])
            i += 1
        else:
            l.append(b[j])
            j += 1
        # 而后，就是按照i，j指针来分别对比两个数，如果在a中的数比b大，那么a往后挪一位，反之亦然
    # 上面while循环后肯定是有一个列表已经被扫完了，而另一个列表还有数剩下来
    # 那么我们就用比较指针和len来判断到底哪个列表被扫完了，哪个列表还存在
    # 还有数存在的那么直接就进行列表拼接即可
    if i == len(a):
        l =  l + b[j:]
    else:
        l = l + a[i:]
    return l