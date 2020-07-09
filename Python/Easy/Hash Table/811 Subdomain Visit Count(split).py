# 这一道题的思路：
# 我们先把数字和string给分开
# 然后将string以.为间隔分开
# 然后将这两者储存到dic里面
# 从dic里面抽内容组成list

class Solution:
    def subdomainVisits(self, cpdomains: List[str]) -> List[str]:
        dic = {}
        for i in cpdomains:
            num,dom = i.split()  #默认分隔符是空格，然后前面空格前，后面空格后
            num,dom = int(num),dom.split('.')   #此处一定要注意将num转变为数字
            for j in range(len(dom)):
                str_ = '.'.join(dom[j:])  #这一部分相当于我将后面domain的部分开始一个个连接
                #这里我们要注意，一定不能写成str不然到后来我们要把int改为str的时候，python是不知道我们要干什么的
                #print(str)
                if str_ in dic:  #来修改字典中的value
                    dic[str_] = dic[str_] + num  
                else:
                    dic[str_] = num
        #print(dic)
        l = []
        for q in dic:  #这抽的就是key，我看到有人写for key,val in dic.items():也是可以的，相当于我们同时抽出key和value
            l.append(str( dic[q] ) + ' ' + q)  
        return l
        #其实最后一部分可以直接写成
        #return [str( dic[q] ) + ' ' + q for q in dic]
        #这样子就不需要再一个个添加到list里面而会自动添加


#别人写的更简单的写法
    def subdomainVisits(self, cpdomains):
        c = collections.Counter()
        for cd in cpdomains:
            n, d = cd.split()
            c[d] += int(n)
            for i in range(len(d)):
                if d[i] == '.': 
                    c[d[i + 1:]] += int(n)
        return ["%d %s" % (c[k], k) for k in c]


#下面这个答案也是有点意思，他的想法就是把最开始用空格来做切割符的全部变成.来做切割符
#然后再进行join连接
class Solution:
    def subdomainVisits(self, cpdomains):
        counter = collections.Counter()
        for cpdomain in cpdomains:
            count, *domains = cpdomain.replace(" ",".").split(".")
            for i in range(len(domains)):
                counter[".".join(domains[i:])] += int(count)
        return [" ".join((str(v), k)) for k, v in counter.items()]