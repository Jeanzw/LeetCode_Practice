# 此题思路：
# 1.只要后一个比我们指定的数字大，那么我们当作卖掉，也就是 大的数 - 小的数
# 2.如果后面的数比我们原本的数小，那么直接换掉我们原本的数


prices = [7,6,4,3,1]
profit = []
for i in range(len(prices)):
    for j in range(i + 1,len(prices)):
        sub = prices[j] - prices[i]
        if sub >= 0:
            profit.append(sub)
        else:
            profit.append(0)
print(max((profit),default=0))
#问Gang，我的做法哪里错了？  
# #逻辑没有问题，但是一旦数据量大了起来，那么结果没有办法跑起来



#另一种做法相当于是进行比较，找到最小的观测值，然后找到最大的利润
min_seen, max_profit = float('inf'), 0  #float('inf')是无限大的意思，因为我们要找的是最小，那么我们的初始值就应该是无穷大
for p in prices:
    min_seen = min(min_seen, p)   #找出最小的观测值
    curr_profit = p - min_seen  
    max_profit = max(curr_profit, max_profit)   #找出最大的profit
print(max_profit)



#上面方法的另一种写法：
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        if len(prices) <= 1:
            return 0
        
        min_price = prices[0]
        max_profit = 0
        for i in range(1,len(prices)):
            max_profit = max(max_profit,prices[i] - min_price)
            min_price = min(min_price,prices[i])
        
        return max_profit