#这道题目的逻辑点就在于：如果这样子拆分遇到了之前有的数字那么就一定是陷入循环之中无法自拔的
n = 19
seen = set()
while n not in seen:
    seen.add(n)   #我们把n加入到集合中，这样子就可以保证整个流程的n都是不同的n
    #因为如果是同一个n就算再来一次，其实走的流程是一样的，那么又会开始无限循环
    #为了避免无isHappy(self, n)限循环挑不出来，我们就设置了这么一个while，这就保证了所有在循环里出现的数字都是第一次出现的，否则跳出循环，因为肯定不是happy number了
    n = sum([int(i) ** 2 for i in str(n)])
print(n == 1)


#Gang的思路就是暴力解法
class Solution(object):
    def isHappy(self, n):
        """
        :type n: int
        :rtype: bool
        """
        existingNums = []  #创一个空list
        while True:
	        if n in existingNums:   #如果在list里面，说明又在循环重复了
		        return False
	        elif n == 1:  #如果sumSquare()这个弄出来是1，那么就是True
		        return True
	        existingNums.append(n)  #如果两者皆不是，那么就把n加入到list里面，并且继续暴力拆分这个数
	        n = self.sumSquare(n)  #如果在class里面调用另一个def那么需要加self
            
    def sumSquare(self, n):  #我们这里先创建一个definition，来将n分解成a^2 + b^2的形式
	    res = 0
	    while n!=0:
		    res += (n%10)**2
		    n /=10
	    return res