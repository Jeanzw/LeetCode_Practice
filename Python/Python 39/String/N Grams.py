def NGram(a,b):
    if len(a) < b:
        return []
    else:
        res = []
        for i in range(len(a)):
            if i + b <= len(a):
                res.append(a[i:i+b])
        return res
