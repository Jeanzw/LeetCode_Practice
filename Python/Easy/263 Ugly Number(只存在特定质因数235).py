#这里其实就是要2,3,5依次粉墨登场，比如说当我num//2余数为0，那么求整后的数就应该赋值给num，再看看继续2,3,5这样子
#这样子循环下去，到最后肯定num = 1
class Solution:
    def isUgly(self, num: int) -> bool:
        list = [2,3,5]
        if num <= 0:
            return False
        else:
            for i in list:
                while num % i == 0:
                    num //= i
        
        if num == 1: #这里无论num原本就是1还是说通过整除后得到的是1都会经过这一步的判断
            return True
        else: 
            return False




#另外还有一种方法就是迭代：recursive，那么其实是要在definition里面进行的
class Solution(object):
    def isUgly(self, num):
        if num <= 0:
            return False
        elif num == 1:
            return True
        q,r = divmod(num,2)  #divmod(a,b)返回的是整除和余数两部分。我们首先把2来作为分母
        if r == 0:  #如果这个数的质因数prime factors有一个为2（即上面的divmod的余数为0），那么就将整除的部分q当做num
            return self.isUgly(q)
        else:
            q,r = divmod(num,3)
            if r == 0:
                return self.isUgly(q)
            else:
                q,r = divmod(num,5)
                if r == 0:
                    return self.isUgly(q)
                else:
                    return False
