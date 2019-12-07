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