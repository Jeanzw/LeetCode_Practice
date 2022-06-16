def CapLett(a):
    split_s = a.split()
    res = []
    for i in split_s:
        res.append(i.capitalize())
    return ' '.join(res)

# 这里其实考的就是大小写转换
# 全员大写upper()
# 全员小写lower()
# 首字母大写capitalize()