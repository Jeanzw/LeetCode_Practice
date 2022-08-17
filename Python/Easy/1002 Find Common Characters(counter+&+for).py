# 存在的知识点：
# 1. 几个单词中找反复出现的字母
# 2. from collections import  Counter -> 来计算在一个string中相同的元素来计数
# 3. & -> 保留相同部分


class Solution:
    def commonChars(self, A: List[str]) -> List[str]:
        from collections import Counter
        n1 = Counter(A[0])
        #n1_new = n1.copy()  #拷贝一个字典
        print(n1)
        for i in range(1,len(A)):
            n = Counter(A[i])
            #print(n)
            for key in n1:
                n1_new = n1.copy()
                if key not in n:
                    del n1_new[key]
                if n[key] != n1[key]:
                    n1_new[key] = min(n[key],n1[key])
                    print(n1_new)
            #print(n1_new)
            n1 = n1_new
        #print(n1_new)
#我的解法涉及到字典的拷贝的问题：https://www.cnblogs.com/cymwill/p/7534224.html

#问Gang我哪里错了？
#修改版：
# 这一个解法的原理其实就是：我们先把第一个单词的字母和个数统计出来，生成dic
# 然后对剩下的单词进行for循环
# 然后将for循环中的单词和第一个单词进行对比，如果不存在，那么就把统计的那个字母给删除；如果存在那么我们就比较个数，取个数小的
# 生成的的dic当作我们第一个单词的dic（相当于做了一个替换）
# 然后替换后新的dic与下一个单词继续同样方式进行对比
class Solution:
    def commonChars(self, A: List[str]) -> List[str]:
        from collections import Counter
        n1 = Counter(A[0])  #统计第一个单词的字母个数，然后生成dic
        print(n1)
        for i in range(1,len(A)):
            n = Counter(A[i])  #对除第一个单词外的单词继续统计个数生成dic，
            #print(n)
            n1_new = n1.copy()  #这里对第一个单词生成的字典进行一个复制，不然我们就需要直接n1了，这样会造成我们没法进行对比
            for key in n1:  #这个时候我们遍历第一个单词构建的dic里面的字母和个数，然后看这个字母是否在for循环中别的单词中 
                if key not in n:  #如果这个字母不在n中，那么我们直接在最开始的n1中删除这个字母就好了
                    del n1_new[key]
                if n[key] != n1[key]:  #就算这个字母在n中，我们也要考虑数量问题，取数量小的
                    n1_new[key] = min(n[key],n1[key])
                    print(n1_new)
            #print(n1_new)
            n1 = n1_new
        print(n1_new)
        return list(n1_new.elements())
        #这里的elements()其实底层的原理是：
            #res = []
            #for key in n1:
		        #for i in range(n1[key]):
			        #res.append(key)
            #return res





#别人的答案
class Solution:
    def commonChars(self, A: List[str]) -> List[str]:
        res = collections.Counter(A[0])
        for a in A:
            res &= collections.Counter(a)   #这里用了&去找相同的部分
        return list(res.elements())
#&的意思就是说，如果两个对比的东西有区别的地方就会被删除
#For Testcase ["bella","label","roller"], common_counter would be
#Counter({'l': 2, 'b': 1, 'e': 1, 'a': 1})
#->
#Counter({'l': 2, 'b': 1, 'e': 1, 'a': 1})
#->
#Counter({'l': 2, 'e': 1})

#elements()
#返回一个迭代器，其中每个元素将重复出现计数值所指定次。 元素会按首次出现的顺序返回。 如果一个元素的计数值小于一，elements() 将会忽略它。
#关于collections更多的说明见：https://docs.python.org/zh-cn/3/library/collections.html



#另外的方法：不用counter()
class Solution:
    def commonChars(self, A: List[str]) -> List[str]:
        l1=list(A[0])
        for i in range(1,len(A)):
            l2=list(A[i])
            l1_copy=[n for n in l1]
            for j in l1_copy:
                if j not in l2:
                    l1.remove(j)
                else:   #如果没有这一步，那么比如说cool和lock，当我扫到第二个o的时候，其实lock里面还有，并不能说明lock里面有两个o，所以这一步相当于保证数量一致，而上面的if则是保证存不存在
                    l2.remove(j)
        return l1