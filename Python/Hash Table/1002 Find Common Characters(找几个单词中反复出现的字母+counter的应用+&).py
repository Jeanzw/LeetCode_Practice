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
class Solution:
    def commonChars(self, A: List[str]) -> List[str]:
        from collections import Counter
        n1 = Counter(A[0])
        #n1_new = n1.copy()  #拷贝一个字典
        print(n1)
        for i in range(1,len(A)):
            n = Counter(A[i])
            #print(n)
            n1_new = n1.copy()  #我们这里从for循环中拿了出来
            for key in n1:
                if key not in n:
                    del n1_new[key]
                if n[key] != n1[key]:
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
            res &= collections.Counter(a)
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