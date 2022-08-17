#贪心算法：只要我们有利益可得，那么我们就把这个利益给得到
#Gang的想法，只要i + 1比i要大，那么我们就卖，不管是不是最大的
#比如说下面的例子，我们在1的时候买在5的时候卖，其实和在1的时候买3的时候卖，同时3的时候买5的时候卖其实收益是一样的
#所以就相当于是说，只要有利可图我们就卖
#那么只要我们后面的价格比前一个价格要高，那么我们就卖，不管是不是最高价
price = [7,1,3,5,2,6,4]
res = 0
for i in range(len(price)-1):
    if price[i] < price[i + 1]:
        profit = price[i + 1] - price[i]
        res += profit
        #print(profit)
print(res)



#另一种想法就相当纯粹了，就是只要后面一个价位比前面一个价位要高，那么就继续扫，一直扫到最高价，求差值
#最高价之后的价格又作为买入价
class Solution(object):
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        i = 0   #这里的i其实相当于是index
        profit = 0  #这里相当于是赚到的钱
        while i < len(prices):
            j = i+1  #我们j就是从i的右边第一位开始扫
            while j< len(prices):
                if prices[j] >= prices[j-1]:  #这里其实就是在保证，右边的数还有更大的，那么就+1继续扫
                    j +=1
                else:  #如果后面的数比前一个要小，那么就停止扫了
                    break
            if prices[j-1]> prices[i]:  #如果说j - 1的时候的价格都比i的时候的价格要大，那么就说明i是最小的
                profit += prices[j-1]-prices[i]
            else:
                i +=1
            i = j   #当我们扫完了这个区间之后，i就变成了最大值右边的一个值，我们又开始买买买
        return profit
