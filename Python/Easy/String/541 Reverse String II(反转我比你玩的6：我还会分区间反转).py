s = "abcdefg"
k = 2
#print(len(s))
if len(s) <= k:
    s = s[::-1]
    print(s)

if k < len(s) <= 2*k:
    i = s[:k]
    print(i[::-1] + s[k:])

if len(s) > 2*k:
    s = list(s)
    #print(s)
    for i in range(0,len(s),2 * k):  #这一部分保证了我其实就是每2k处理一次
        s[i:i + k] = reversed(s[i:i + k])
    #print(s)
    s = "".join(s)
    print(s)



#其实可以直接用最后一个步骤
def reverseStr(self, s, k):
    s = list(s)
    for i in xrange(0, len(s), 2*k):
        s[i:i+k] = reversed(s[i:i+k])  
    return "".join(s)    