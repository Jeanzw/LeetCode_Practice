S = "loveleetcode"
C = 'e'
s_list = list(S)
#print(s_list)

#for i in s_list:
    #if i == C:
        #print(s_list.index(i)) 我们这种方式是只可以得到第一个存在的e，而不能得到所有e的index
        #这个时候我们就可以用enumerate来帮助我们了




#思路1：
#我自己的思路就是，先找到S中C存在的index，然后再求出S所有的index，然后依次相减求最小值
loc = []
for i,x in enumerate(s_list):  #这里我们相当于是抽取index以及value
    if x == C:
        #print(i)
        loc.append(i)
print(loc)

#上面我们其实就是利用enumerate来帮助我们找到特定x对应的index
#但是还可以用别的方法:range
#list = []
#for i in range(len(s_list)):
    #if s_list[i] == C:
        ##print(i)
        #list.append(i)
#print(list)

#我们下面输出s_list所有的index就用range来试
line = []
for q in range(len(s_list)):  #这里我们相当于是抽取index以及value
        #print(q)
        line.append(q)
print(line)

#下面的步骤就是我们对上面e所在的index和所有值的index分别求绝对值的过程
res = []
for i in line:    
    mins = []
    for j in loc:
        sub = abs(i - j)
        mins.append(sub)  #我们这里相当于是说，先把对应的距离求出来，再到之后用min来求这个列表中的最小值
    output = min(mins)
    #print(output)
    #print(type(output))
    res.append(output)
print(res)






#Gang的思路：
#我相当于有一个指针，然后有两个点需要我注意就是previous点和positio点
S = "loveleetcode"
C = 'e'

n = len(S)
prev = -1  #我们让previous点 < 0那么保证我们无论如何都是从第一个开始走
pos = S.find(C)  #用find()发现第一个C存在的index
print(pos)
res = [0]*n   #我们这里相当于说是创建一个有n个0的list，当做一个初始化，那么只要是S里面的字母和C一样，那么就是0，别的直接更换就好了
print(res)
for i in range(pos):  #这时候相当于是从第一个字母到第一个C存在的地方
    res[i] = pos-i   #我们将二者位置之差来替换之前我们创建的全为0的list res
prev = pos  #然后我们来讨论第一个C出现的右边，那么原本的pos就变成了我们左边的区间，而右边的区间就是最后一个字母的时候
for i in range(pos, n): 
    #第一次进入这个大循环的时候肯定不满足第一个if的，因为这个时候的pos还是原本的pos，但是我们已经讨论原本pos右边的区间了
    #那么在i < pos就不满足，所以直接跳到第二个if，将原本的pos变成prev，而现在pos变成第二个C存在的地方
    if i<pos and pos!=-1:
        if pos-i < i-prev:
            res[i] = pos-i
        else:
            res[i] = i-prev
        #上面的if和else可以直接改成res[i] = min(pos-1,i-prev)
    elif pos!=-1:  
    #这一个elif是不可以和上面的if替换的，因为上面的是说，我已经在prev和pos区间里面行走了
    #而这里的elif相当于是说，我并没有在里面行走，同时我们的pos的位置又不是最后一个
        prev = pos
        pos = S.find(C, pos+1)   #find()方法如果两个参数，就相当于是从前一个往后找第二个的C
    else:
        res[i] = i-prev
print(res)

#如果实在想不明白，那么就自己走一遍