#我的做法：
class Solution:
    def reorderLogFiles(self, logs: List[str]) -> List[str]:
        let = []
        dig = []
        
        for i in logs:
            if i[:3] == 'let':
                let.append(i)
            else:
                dig.append(i)
        print(let)
        print(dig)
        print(let + dig)
        let.sort(key,l = lambda x: (' '.join(x.split()[1:]), x.split()[0]) ) 
        print(let)
        return let + dig

#这里我觉得我理解错了题目的意思了，前面的identifier是什么都无所谓，主要是看后面的内容
#而题目中又一个很重要的说法就是：如果是dight那么全部都是由数字组成，否则全部都是由字母组成



#问题：
#1.如何用lambda
#2.如何对“xxx”的后半部分进行排序
#所以正确的判断是否是数字还是字母的方法是
class Solution:
    def reorderLogFiles(self, logs: List[str]) -> List[str]:
        lets = []
        digs = []
        
        for i in logs:
            if i[-1].isdigit():  #isdigit()用来判断是否是数字
                #isalpha()用来判断是否是字母
                digs.append(i)
            else:
                lets.append(i)
        
        print(lets)
        print(digs)
        #接下来就是要来看如何对lets进行排序了
        lets.sort(key = lambda x:(' '.join(x.split()[1:]),x.split()[0]))  
        #这里的意思就是：我们既要对后面的内容x.split()[1:]进行排序，也对identifier进行排序x.split()[0]
        print(lets)
        return lets + digs
        
#python排序函数sort()与sorted()区别：https://blog.csdn.net/zyl1042635242/article/details/43115675
#sort会对原来的内容进行改动，而sorted不会
#Python List sort()：programiz.com/python-programming/methods/list/sort



#Gang的思路，我们把原来的lets进行重新组合，让前面的identifier滚到后面去，然后对新组合进行排序，然后再重新拼接
class Solution:
    def reorderLogFiles(self, logs: List[str]) -> List[str]:
        lets = []
        digs = []
        
        for i in logs:
            if i[-1].isdigit():  #isdigit()用来判断是否是数字
                #isalpha()用来判断是否是字母
                digs.append(i)
            else:
                lets.append(i)
        
        print(lets)
        print(digs)
        for i in range(len(lets)):
            print(i)
            words = lets[i].split()
            print(words)
            lets[i] = ' '.join(words[1:]) + ' ' +words[0]
        print(lets)  #这个时候的lets是已经拼接好的，也就是说我们把原本的identifier放到最末端，把原本后面的部分放到前面来
        
        lets.sort()  #这里进行排序，注意，sort()是会直接影响原来的list的
        print(lets)
        #这个时候已经将lets进行排序好了，那么我们就继续重新拼接成原来形式
        for i in range(len(lets)):
            words = lets[i].split()
            lets[i] = words[-1] + ' ' + ' '.join(words[:-1])
        print(lets)
        
        return lets + digs