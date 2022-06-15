def RevSen(a):
    split_s = a.split()
    res = split_s[::-1]
    return ' '.join(res)
# 这里涉及三个知识点
# 1. 如何将string分开：用split，默认是按照空格分开，如果要按照别的分开比如逗号，那么用split(',')
# 2. 如何将list里面的value给倒过来
# 3. 如何将list合并成string: 用join，如果需要用逗号连接，那么就是','.join(res)