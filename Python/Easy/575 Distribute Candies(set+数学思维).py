# 这一道题目的思路其实很简单：
# 题目的意思其实就是，糖果分一半，那么妹妹最多可以得到多少种类的糖果呢？
# 由于哥哥和妹妹是一人一半，所以妹妹最多也就分到一半的糖果，就算这些糖果都不是一个种类的，也就只能分到一半数量糖果种类的糖果
# 所以这就说明，总数/2 这是一个分界点，也是我们讨论的依据


class Solution:
    def distributeCandies(self, candies: List[int]) -> int:
        kind = set(candies)
        print(kind)
        if len(kind) >= len(candies)/2:  #如果糖果种类大于总糖果数的一半的话，那么其实无论妹妹怎么拿，最多也只能得到总糖果数一半数量的种类
            return int(len(candies)/2)
        else:  #如果糖果种类小于总糖果数的一半的话，那么妹妹最多也就是把所有种类的糖果全部拿完
            return len(kind)
        
        
        

#另一种思路：
#我们假设说这里有n种不同的糖果len(set(candies))，然后妹妹也只能拿走其中的一半而已len(candies) / 2
#我们打个比方，如果这里有5种不同的糖果，如果妹妹要拿走4个，那么4种糖果都可以不同
        #但是如果这个时候，妹妹其实要拿走的糖果数量是7个呢？那么必定是有重复的，但是糖果种类最多也只能是5种
print(min(len(candies) / 2, len(set(candies))))

