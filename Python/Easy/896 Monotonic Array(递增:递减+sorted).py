# 对于这种需要判断是否是递增或者递减的array，我们的思路可以有以下几种
# 1. 直接对原本的array进行sort排序，如果是和原本的array一致，那么就说明是递增或者递减
# 2. 对于递增或者递减的array一定会有这样的规律：(A[i + 1] - A[i]) * (A[i] - A[i - 1]) >= 0

class Solution:
    def isMonotonic(self, A: List[int]) -> bool:
        a = sorted(A)
        #print(a)
        b = sorted(A,reverse=True)
        #print(b)
        if a == A or b == A:
            return True
        else:
            return False
        #关于sort以及sorted的学习内容：https://www.jianshu.com/p/7be04a3f30cd



#别人的一种想法就是说，我们利用差值，如果一直增或者一直减，那么前两个差值和后两个差值的乘积应该都是大于0的
#一旦发现乘积小于0，那么就说明不是一直增或者一直减
class Solution(object):
    def isMonotonic(self, A):
        """
        :type A: List[int]
        :rtype: bool
        """
        prev = 0

        N = len(A)
        if N < 3: return True

        for i in range(1, N):
            d = A[i] - A[i-1] 
            # 我们需要确认d != 0，不然对于这样的例子：[11,11,9,4,3,3,3,1,-1,-1,3,3,3,5,5,5] 就会出现错误答案
            # 上面这个例子在[11,11,9,4,3,3,3,1,-1,-1]过程中都是没有问题的，坏就坏在了之后的[-1,3,3,3,5,5,5]
            # 我们在这里添加d != 0 就可以相当于我们把一样的例子都给去掉了，那么就不存在上面的特殊情况了
            if d != 0:
                if prev == 0:
                    prev = d
                elif prev * d < 0:
                        return False
        return True


#另外还有想法直接用all（）来做
class Solution:
    def isMonotonic(self, A: List[int]) -> bool:
        return all((A[j-1] <= A[j] for j in range(1, len(A)))) or all((A[j-1] >= A[j] for j in range(1, len(A))))