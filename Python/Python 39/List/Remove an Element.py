def RmEl(a,b):
    if b in a:
        return a.remove(b)
    else:
        return a


# # remove element from a list 的几种方法：
# 1. remove()：
# # 这个方法是只可以把第一次出现的element给去掉
# # 比如说test_list1 = [1, 3, 4, 6, 3]
# # test_list1.remove(3)
# # 那么得到的结果是：[1, 4, 6, 3]
# # 第一个3会被移走，但是第二个3还是存在的
# 2.  set.disard()：
# # 这个就是说先把原来的list给转移成set，这样子可以预处理掉重复值，然后再用discard来把对应的element给删掉
# # 比如说test_list2 = [1, 4, 5, 4, 5]
# # test_list2 = set(test_list2) -> 得到的结果是[1,4,5]
# # 然后test_list2.discard(4) -> 相当于在set里面把4给剔除
# # test_list2 = list(test_list2) -> 把set转变回list
# # 得到的结果是：[1, 5]
# 3. 还可以直接使用for循环来遍历整个list，剔除掉不需要的内容
# 4. pop()：
# # 这个涉及两个知识点pop(index)是按照index把对象轰出去，index(element)是可以通过element在list里面找对应的index
# # test_list3 = [1, 3, 4, 6, 3]
# # rmv_element = 4 -> 想要移除的element是4
# # if rmv_element in test_list1:  #开始用for循环依次炮轰
# #     test_list1.pop(test_list1.index(rmv_element)) -> 用index找到rmv_element对应的index，然后用pop给轰出去
# # 得到的结果是：[1, 3, 6, 3]