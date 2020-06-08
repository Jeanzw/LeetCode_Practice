str = "Let's take LeetCode contest"
list = str.split(' ')
print(list)
str1 = ' '.join(list)  #这里我们要在''里面加空格，那么我们加入的每一个list里面的元素才可以之间有空格
print(str1)
#上面的就是list 和 string得相互转换

#方法1：切片法
list1 = []
for i in list:
    list1.append(i[::-1])
print(list1)
res = ' '.join(list1)
print(res)


#方法2：reverse()函数
#这个函数是将列表的内容进行反转，那么借助这个特性，我们将str里面的每一部分抽出来之后，再将单独的i变成列表的形式进行翻转就好了
for i in list:
    list_i = i.split()
    list = list(list_i)
    print(list)
    print(type(list))
    #list_r = list_i.reverse()
    #print(list_r)
