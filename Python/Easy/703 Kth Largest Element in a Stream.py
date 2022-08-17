#我们就拿题目给我们的例子来作为论述
#首先要看有这么一个包heapq：https://docs.python.org/2/library/heapq.html
#int k = 3;
#int[] arr = [4,5,8,2];
#KthLrgest a = new KthLargest(3, arr);
#a.add(3);   // returns 4
#a.add(5);   // returns 5
#a.add(10);  // returns 5
#a.add(9);   // returns 8
#a.add(4);   // returns 8

#我们利用min-heap，相当于从小到大进行排序这个heap，要注意虽然这个是heap这样的形式，但是总体其实还是list的本质
#        2
#    4       5
#因为我们的k = 3，所以我们pop掉直到整个list长度为3,然后剩下的元素进行重新组合成heap的形式，这样我们保证了尖尖端一直都是第3大的
#pop(2)
#=>     4
#   5       8


#由于我们要add(3),将3这个数字加入进去
#=>          3
#        4       5
#    8
#由于这个时候长度大于3，所以继续pop掉最小的，也就是最上面的数字，然后剩下的数字继续进行组合
#pop(3)
#=>     4
#   5       8


#add(5)
#=>          4
#        5       5
#    8
#pop(4)
#=>     5
#   5       8


#add(10)
#=>          5
#        5       8
#    10
#pop(5)
#=>     5
#   8       10


#add(9)
#=>          5
#        8       9
#    10
#pop(5)
#=>     8
#   9       10


#add(4)
#=>          4
#        8       8
#    10
#pop(4)
#=>     8
#   9       10


#所以最后是return 8


import heapq
class KthLargest:

    def __init__(self, k: int, nums: List[int]):
        self.hlist = nums  #由于是实例化，所以要用self，不然在下面add（）这一个definition里面就没有办法调用了
        # 而这里的hlist其实是没有任何意义的，只是起个名字
        heapq.heapify(self.hlist)   #将上面的list弄成heap的形式
        self.k = k   #告诉python我们要拿最大k的值
        while len(self.hlist) > k:
            heapq.heappop(self.hlist) #如果原始长度大于k，那么我们直接把长于k的别的值给pop掉，这样保证我们的heap里面就是只有k个元素
        # 以上操作我觉得其实是做一个准备工作
        # 也就是说，先把heap list给设置好，这里使用了heapq.heapify()
        # 而后也告诉了python我们的k是多少
        # 同时用一个while循环告诉python，我们需要的长度是怎样的，而多余的就用heapq.heappop()给踢掉
        # 以上操作其实就决定了我们整个heap的结构了

    def add(self, val: int) -> int:
        heapq.heappush(self.hlist,val)  #将val给添加到self.hlist来
        if len(self.hlist) <= self.k:
            return self.hlist[0]  #如果我们原本里面的元素就是比k要少或者就是等于k，那么无论如何都会返回第一个
        #否则，我们要把多出来的部分的最小值继续pop掉
        heapq.heappop(self.hlist)
        return self.hlist[0]  #然后取剩下部分的尖尖端
# Your KthLargest object will be instantiated and called as such:
# obj = KthLargest(k, nums)
# param_1 = obj.add(val)


#拓展：
#上面的部分是弄一个min-heap，相当于从小到大，而如果我们要弄一个max-heap，从大到小呢？
#https://stackoverflow.com/questions/2501457/what-do-i-use-for-a-max-heap-implementation-in-python
#import heapq 
#listForTree = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] heapq.heapify(listForTree) # for a min heap
#heapq._heapify_max(listForTree) # for a maxheap!!