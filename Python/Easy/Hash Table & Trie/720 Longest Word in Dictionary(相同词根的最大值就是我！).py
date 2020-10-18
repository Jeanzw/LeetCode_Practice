#If there is more than one possible answer, return the longest word with the smallest lexicographical order
#上面的这句话，其实就是说，其实我们要选在比大小的过程中选更小的
print('apple'>'apply')   #返回的是：False

words = ["a", "banana", "app", "appl", "ap", "apply", "apple"]
def longestWord(self, words):
    words.sort(key=lambda x: (-len(x), x))
    d = set(words)
    for word in words:
        # break if word not in d
        if all(word[:i] in d for i in xrange(1, len(word))):
            # break if we have found the result
            return word
    return ''




class Solution:
    def longestWord(self, words):
        """
        :type words: List[str]
        :rtype: str
        """
        res, lookup = "", set(words)
        for word in words:
            if len(word) > len(res) or (len(word) == len(res) and word < res):
                satisfy = True
                i = 1
                while i < len(word):
                    if word[:i] not in lookup:
                        satisfy = False
                        break
                    i += 1
                if satisfy: res = word
        return res




#Gang的思路
class Solution(object):
    def longestWord(self, words):
        """
        :type words: List[str]
        :rtype: str
        """
        # words = xxx
        words.sort(key = lambda x: len(x),reverse = True)  #这里相当于是将words这个列表里头的values按照长度从大到小进行排序
        res = “”
        for word in words:
            if len(word) < len(res):  #我们这里的意思其实就是，当我们找到比最长的values要短的value的时候就可以结束这个循环了，因为它肯定不是我们要找的东西
		        break
	        canFind = True  #这个是属于熟能生巧的内容，加一个flag来帮助我们进行判断
	        for i in range(1,len(word)):   #[‘apple’,’'worla', 'world', 'worlb', 'worl', ‘app’,'wor', 'wo', 'w']
		        if word[:i] not in words:  #这里的if判断其实就是帮我们筛选掉词根不在list里面的单词，比如说上面的内容就是apple以及app就是会走这一块然后进行筛选掉，直接跳出循环
			        canFind = False  #但是我们要知道，跳出循环是跳出里头的这个for i in range()这个循环，而不是最外头的那个大循环，所以这里头必须要将canFind从True变成False然后帮助我们下面进行判断
			        break
	        if canFind:  #这里如果canFind还是保持的是True，那么就说明已经是词根在list里面的单词了
		        if word < res or res == “”:
                    #这里存在的两个内容：
                    #①在第一次更新的时候，res = ''，那么就是满足or右边的内容，进行赋值
                    #②之后更新之后，其实就是在找都是最长的单词，比较lexicographical order的问题。
			        res = word
        return res
