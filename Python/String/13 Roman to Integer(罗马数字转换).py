s = 'MCMXCIV'
dic_roman = {'I':1,'V':5,'X':10,'L':50,'C':100,'D':500,'M':1000}
#print(dic_roman)
sl = len(s)
#print(sl)
num = 0
for i in range(sl-1):  #之所以我们的range是要-1那是因为我们之后if判断的时候有一个i + 1所以我们可以把最后一个数字单独拿出来考虑就好了
    if s[i] == 'I' and s[i+1] in ['V','X']:
        num -= 1
    elif s[i] == 'X' and s[i+1] in ['L','C']:
        num -=   10
    elif s[i] == 'C' and s[i+1] in ['D','M']:
        num -= 100
    else:
        num += dic_roman[s[i]]
num += dic_roman[s[-1]]
print(num)


#下面的这种做法是因为题目中的这一句话：Roman numerals are usually written largest to smallest from left to right.
#所以我们可以根据左右两边的大小来判断异常值
s = 'MCMXCIV'
dic = {'I':1,'V':5,'X':10,'L':50,'C':100,'D':500,'M':1000}
num = 0
for i in range(len(s) - 1):
    if dic[s[i+1]] > dic[s[i]]:
        num -= dic[s[i]]
    else:
        num += dic[s[i]]
num += dic[s[-1]]
print(num)