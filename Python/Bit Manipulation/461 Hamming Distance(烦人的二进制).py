#这一道题目的意思其实就是如果我们把数字变成二进制，那么对应进制不同的个数有多少
x = 1  #对应二进制是：0 0 0 1
y = 4  #对应二进制是：0 1 0 0
res = bin(x^y).count('1')
#https://m.runoob.com/python/python-operators.html
#这里使用的是位运算符 ^，当两对应的二进制相异时，结果就是1，比如上面的1和4，那么对应下来就是0101
#bin()其实就是
#那么我们接下来就是算1的个数就好了，就用的是count来计数
print(res)



#下面的这种方法就是非常纯粹的想法了，首先我们要明白一个道理就是：
#比如说十进制的情况下，12 / 10 那么当我求余的时候，就相当于把最右边的数字给剥离出来
#比如说1356在十进制的情况下，余数是6，那么其实就是把6从1356这个数字中剥离出来，然后求整的部分就是135
#继续除10，那么余数就是5，求整部分是13
#继续除10，余数就是3，求整部分就是1

#同理，如果我们在二进制的情况下，就是要用1356 / 2，那么余数就是1356转换为2进制的情况下，最右边的数，只可能是0或者1
#比如说3的二进制形式是011 （2^0 + 2^1 = 3)
#当我们对3进行divmod(3,2)，那么余数就是1，那么其实就是其二进制形式下最后变得1
if y == x:
    print(0)
elif y < x:
    temp = x
    x = y
    y = temp
count = 0   #这一步之前我们都是在保证x是比y小的，如果x比y要大，那么我们就替换x和y的位置就好了
while x > 0:
    x, x_res = divmod(x, 2)  #对x和y求整合求余，并把得出的求整部分继续赋值回给x和y
    y, y_res = divmod(y, 2)
    if x_res != y_res:  #我们x和y的求余部分如果不一样，那么就说明这一位的二进制的数字是不一样的，那么就可以+1
        count += 1
while y > 0:   #因为我前面保证了x<y，所以当我们x搞定之后y肯定还没有走完，所以这里我们直接走y就好了
    y, y_res = divmod(y, 2)
    if y_res != 0:  #只要二进制位数是1，那么就+1，因为默认二进制左边全为0
        count += 1
print(count)
