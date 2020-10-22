class RecentCounter(object):
    def __init__(self):
        self.nums = []   
        #之所以我们这里是要建立一个实例，是因为我们后来每一次哦毒药调用一次ping()，如果没有建立一个实例，那么每一次调用就会忘记我们之前调用的内容
        #而这里调用了一个实例，那么就相当于是会记住每一次调用的内容

    def ping(self, t):
        self.nums.append(t)
        index = -1
        for i in range(len(self.nums)):
            if t-self.nums[i]>3000:
                index = i
        self.nums = self.nums[index+1:]
        return len(self.nums)

# Your RecentCounter object will be instantiated and called as such:
# obj = RecentCounter()
# param_1 = obj.ping(t)




#另外一种方法就是用python自己的queue这一种方法，先进先出
class RecentCounter(object):
    def __init__(self):
        self.q = collections.deque()
#https://docs.python.org/2/library/collections.html
    def ping(self, t):
        self.q.append(t)
        print(self.q)
        while self.q[0] < t-3000:
            self.q.popleft()
        return len(self.q)
        


# Your RecentCounter object will be instantiated and called as such:
# obj = RecentCounter()
# param_1 = obj.ping(t)


#collections.deque的用法简介：
#from collections import deque
#queue = deque(["Eric", "John", "Michael"])
#queue.append("Terry")           # Terry 入队
#queue.append("Graham")          # Graham 入队
#queue.popleft()                 # 队首元素出队
##输出: 'Eric'
#queue.popleft()                 # 队首元素出队
##输出: 'John'
#print(queue)                           # 队列中剩下的元素
##输出: deque(['Michael', 'Terry', 'Graham'])
————————————————