left = 1
right = 22
list = []
for i in range(left,right+1):
    if i < 10:
        list.append(i)
    else:
        for l in str(i):
            if int(l) == 0 or i % int(l) != 0:
                break
        else:
            list.append(i) 
print(list)

#我上面其实是先对i做了一个判断，但是其实完全没有必要做这个判断
for i in range(left,right+1):
    for l in str(i):  #我们这个循环其实就是为了把不满足我们条件的数字都给挑出来跳过，然后满足条件的数字直接进入else，加入到list里面
        if int(l) == 0 or i % int(l) != 0:
             break
    else:
        list.append(i) 
print(list)