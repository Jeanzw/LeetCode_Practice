class Solution:
    def findLHS(self, nums: List[int]) -> int:
        from collections import Counter
        cnt = Counter(nums)
        #print(cnt)
        cnt = sorted(cnt.items())  #此处我们的想法其实就是，让key从小到大进行排序，而后我们只要将相差为1的key的value相加，然后就是长度了，然后取最长的组合
        # 这样子处理之后其实cnt就变成了一个二维数组
        #print(cnt)
        ans = 0
        for i in range(1,len(cnt)):
            #print(key,value)
            #print(i)
            #print(cnt[i][0])
            if cnt[i][0] == cnt[i - 1][0] + 1:
                total = cnt[i][1] + cnt[i - 1][1]
                #print(total)
                maxi = max(ans,total)
                ans = total
        return maxi



#上面这种解法在遇到了【1，1，1，1】这种情况就会报错，当出现【1，1，1，1】的时候，结果其实应该是0
#这里我们要直到一件事情就是，我们如果在比较大小的时候，其实在循环里面的值最好不要返回，因为一旦进入不了循环，那么就没有返回值了
#gang帮我改的结果如下，这样子就可以解决这个问题了
class Solution:
    def findLHS(self, nums: List[int]) -> int:
        from collections import Counter
        cnt = Counter(nums)
        #print(cnt)
        cnt = sorted(cnt.items())
        #print(cnt)
        res = 0
        for i in range(1, len(cnt)):
            #print(key,value)
            #print(i)
            #print(cnt[i][0])
            if cnt[i][0] == cnt[i - 1][0] + 1:
                total = cnt[i][1] + cnt[i - 1][1]
                #print(total)
                res = max(res,total)
        return res

