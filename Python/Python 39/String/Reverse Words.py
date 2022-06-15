def RevWords(a):
    split_s = a.split()
    res = []
    for i in split_s:
        res.append(i[::-1])
    return ' '.join(res)