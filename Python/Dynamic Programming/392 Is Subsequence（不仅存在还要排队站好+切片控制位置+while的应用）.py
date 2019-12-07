def isSubsequence(self, s, t):
    for c in s:
        i = t.find(c) #寻找c对应的index
        if i == -1:   #如果find找不到对应的index，那么就会显示False
            return False
        else:
            t = t[i+1:]   #一旦我们找到了对应的index，那么为了保证顺序问题，我们可以直接把前面的部分给舍弃，形成一个新的string
    return True

#如果上面把return都换成了print其实是得不到我们想到的答案的，因为下面的True无论如何都会打印出来
#但是在def中，只会return一个内容，所以一旦return了上面的False，那么下面的True不会return出来


s = "abh"
t = "ahbgdc"
#另一种和我原本的想法比较像的思路：遍历法

#我原本的思想：
#错误原因：
#我上面的做法是会报错的，因为index永远都是抽取第一个出现的，而如果我们的s是leet这样子的，第二个e还是会显示第一个e出现的index
def isSubsequence(self, s, t):
    """
    :type s: str
    :type t: str
    :rtype: bool
    """
    ori_j = 0
    for i in s:
        if i in t:
            #print(t.index(i))
            if t.index(i) >= ori_j:
                ori_j = t.index(i)  #index抽取的永远是第一个出现的index
                #我这一步的想法其实就是相当于要推动index的大小来保证顺序
                #既然这样不行，那么我们就使用计数的方法来保证顺序
            else:
                return False
        else:
            return False
    return True


#我的想法的修改：
if len(s) == 0:
    print(True)
if len(t) == 0:
    print(False) 
i, j = 0, 0
while i < len(s) and j < len(t):
    if s[i] == t[j]:
        i += 1  #这其实就是如果s和t的value是一样的，那么我们就去看下一个i的value
    j += 1   #如果此时的j对应的value和i对应在s上的value不一样，那么我们就看t的下一个value是不是一样，+1其实保证一定是往右走不回头
if i == len(s):
    print(True)
else:
    print(False)

#同样思路，更简单的写法：
def isSubsequence(self, s: str, t: str) -> bool:
    l_s, l_t = len(s), len(t)
    i, j = 0, 0
    while i < l_s:
        while j < l_t and t[j] != s[i]:
            j += 1
        if j == l_t:
            return False
        i, j = i + 1, j + 1
    return True
