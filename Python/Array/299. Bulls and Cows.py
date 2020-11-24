

# 下面是其中一个错误，
# 当我们输入
# "1122"
# "1222"
# 那么按照下面的程序走得到的结果是："2A1B"
# 但是应该得到的结果是"3A0B"
# 那是因为原本我们应该认为index = 0/2/3的时候是对齐的，也就是获得bulls，而对于index = 1的情况，那么就当作什么都没有，那么就是cows = 0

class Solution:
    def getHint(self, secret: str, guess: str) -> str:
        secret = list(secret)
        guess = list(guess)
        secret_dic = Counter(secret)
        print(secret_dic)
        
        bulls = cows = 0
        for i in range(len(guess)):
            if guess[i] in secret_dic:
                if guess[i] == secret[i]:
                    bulls += 1
                else:
                    cows += 1
                secret_dic[guess[i]] -= 1
                if secret_dic[guess[i]] == 0:
                    del secret_dic[guess[i]]
        return str(bulls) + 'A' + str(cows) + 'B'




# 对于上面这个例子，我们就要知道，其实是bulls优先，当bulls考虑不了的时候我们再考虑cows
# 那么我们就使用两个for
# 第一个for，那么就是来看有多少个bulls，每找到一个，那么就减去一个
# 第二个for，就是来看有多少个cows
class Solution(object):
    def getHint(self, secret, guess):
        """
        :type secret: str
        :type guess: str
        :rtype: str
        """
        cnts = Counter(secret)
        
        a = b = 0
        for i in range(len(guess)):
            if secret[i] == guess[i]:
                a +=1
                cnts[secret[i]] -=1
        
        for i in range(len(guess)):
            if secret[i] != guess[i] and cnts[guess[i]] > 0:
                cnts[guess[i]] -=1
                b +=1
        
        return str(a) + "A" + str(b) + "B"
        
