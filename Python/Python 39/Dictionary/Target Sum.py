# 这道题有两种解法：
# 方法1： 利用双重index去扫描index，但是效率比较低
def TargetSum(a,b):
    for i in range(len(a) - 1):
        for j in range(1, len(a)):
            if a[i] + a[j] == b:
                return [i,j]
    return - 1
# 方法2：利用dic，key是要寻找的另一半数字，而value就是当前index
def TargetSum(a,b):
    dic = {}
    for i in range(len(a)):
        if a[i] not in dic.keys():
            dic[b - a[i]] = i
        else:
            return [dic[a[i]],i]
    return -1