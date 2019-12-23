from collections import Counter
s = "abccccdd"
dic = Counter(s)  #使用Counter模块统计一段句子里面所有字符出现次数
print(dic)  #对于字母和字符串的题目，我们可以从统计个数的角度入手
#如果我们要获取出现频率最高的3个字符
#print(dic.most_common(3))




#下面gang写的其实就是先一步步来计算字母的个数，然后再来计算
count = dict()  #我们先创建一个空字典
for i in range(26):
        count[chr(ord('a')+i)] = 0  #这里我相当于往字典里面加入小写的26个字母，然后他们的value都是0
for i in range(26):
        count[chr(ord('A')+i)] = 0  #这里我相当于往字典里面加入大写的26个字母，然后他们的value都是0
for c in s:
        count[c] +=1   #我们这里相当于在统计string里面的字母的个数

odds = 0   #我们这里计算value是奇数的key的个数
for key in count:
    if count[key]%2 !=0:   #这里是去找key对应的value是否是奇数。我们在这里只需要管奇数的个数，因为偶数的话无论如何都可以颠倒
        odds +=1      #如果某个key对应的value是奇数，那么我们就计算这个是个奇数
print(len(s) - odds + (odds > 0))   #而这个最长组合的情况其实就是string的总长度 - 奇数 + 1（如果有奇数的话）
#这里add > 0就是1， = 0就是0
#这里举个例子
#aabbbcccddee
#a = 3
#b = 3
#c = 3
#d = 2
#e = 2
#我们这里其实可以把奇数的abc都去掉一个，那么就可以对称了，但是因为我们中间可以放一个奇数而不一定要是偶数，所以如果存在奇数的字母，我们可以多加一个在中间

