# https://www.delftstack.com/howto/python/sort-list-of-lists-in-python/

# a.sort() -> 直接改变a，让a按照顺序排列
# sorted(a)-> 并不改变a的顺序 
# a.insert(x,y) -> 在list a中的index = x的地方插入y

def SortLL(a):
    last_num = []
    # 我们先用一个for循环把每个list的最后一位数取出来，然后排序
    for i in a:
        last_num.append(i[-1])
    last_num.sort()
    # return last_num
    res = []
    # 然后来将最后一位和每个list来进行对照
    for j in range(len(last_num)):
        for i in a:
            if i[-1] == last_num[j]:
                res.insert(j,i)
    return res