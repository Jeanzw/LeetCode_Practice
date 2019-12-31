#方法1：
#其实python里面有直接大小写转换的方法
#str.upper()         # 把所有字符中的小写字母转换成大写字母
#str.lower()         # 把所有字符中的大写字母转换成小写字母
#str.capitalize())   # 把第一个字母转化为大写字母，其余小写
#str.title())        # 把每个单词的第一个字母转化为大写，其余小写 
str = 'Hello'
print(str.lower())



#方法2：
#但是我们这里明显不是要用这种直接的方法，所以我们可以使用ASCII
#a-z：97-122
#A-Z：65-90
#相当于大小写在ASCII里面相差32
str = 'Hello'
s = ''   #对于字符串，我们也就弄出一个空的字符串，然后在之后把新生成的内容给一个个加进去就好了
for i in str:
    if 65 <=ord(i) <= 90:
        s += chr(ord(i)+32)
    else:
        s += i
print(s)



#方法3：
#另外可以用index来作为大写字母的定位，而不用像上面的那种全部进行替换
str = 'Hello'
list = list(str)   #字符串本身是没有定位的，但是如果我们转换成list那么就可以进行定位了
for i in range(len(list)):
    if 65 <=ord(list[i]) <= 90:
        a = list[i]
        list[i] = chr(ord(a)+32)  #这里相当于就是给大写字母来做替换，list[i]做了一个定位，然后在这里做一个替换，别的list[i]没有丝毫改变，不进入if语句中
#Python join() 方法用于将序列中的元素以指定的字符连接生成一个新的字符串。
        #str.join(sequence)
str = ''.join(list)
print(str)
