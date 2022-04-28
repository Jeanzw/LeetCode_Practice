class Solution:
    def mySqrt(self, x: int) -> int:
        left,right = 0, x
        res = 0
        while left <= right:
            mid = (left + right) // 2
            if mid * mid <= x: #我们之所以这里可以用等于号，是因为我们最后的结果是取靠左的数
                res = mid #先让res把mid的这个坑给占住了
                left = mid + 1 #如果mid ** mid要比x小，那么就说明真正的平方根是比当前的mid要大的，那么我们就可以将左边的数换成mid，然后继续来二分法比较
            elif mid * mid > x:
                right = mid - 1
        return res