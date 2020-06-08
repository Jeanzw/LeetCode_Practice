class Solution:
    def mostCommonWord(self, paragraph: str, banned: List[str]) -> str:
        from collections import Counter
        symbols = ' !?\',;. '
        for i in symbols:
            paragraph = paragraph.replace(i,' ')   #将标点符号进行替换成空格，这样方便我们接下来的split
        p = str.lower(paragraph)
        p = p.split()
        #print(p)
        cnt = Counter(p)
        #print(cnt)        
        #上面一部分相当于我们在数单词个数
        

        dic = {}
        for key in cnt:
            if key not in banned:
                dic[key] = cnt[key]
        print(dic)
        max_value = max(dic.values())
        print(max_value)
        res = ''
        for k,v in dic.items():
            if v == max_value:
                res = key
        return res 
#上面是第一版答案，最开始我是想计算出每个单词个数，然后求出最大的个数，去找那个个数对应的单词，这样真的太麻烦太麻烦了！！！
#另外我还想像594这一道题一样，利用sorted来排序出个数，不过sorted是针对key来排序，594那一道题的key就都是数字，所以可以这样做，但是这一道题目并不是这样的情况



#于是我们采用另一种方法去找最大value对应的key，我们就通过不停的动态替换
#对于一个key和其对应的value，如果value大于上一个我扫出来的value那么这个时候最大值就进行了替换，然后对应的key记录下来
#直到我扫出来最后的结果就是最大值再也不变了
class Solution:
    def mostCommonWord(self, paragraph: str, banned: List[str]) -> str:
        from collections import Counter
        symbols = ' !?\',;. '
        for i in symbols:
            paragraph = paragraph.replace(i,' ')   #将标点符号进行替换成空格，这样方便我们接下来的split
        p = str.lower(paragraph)
        p = p.split()
        #print(p)
        cnt = Counter(p)
        print(cnt)        
        #上面一部分相当于我们在数单词个数
        
        
        res = ''
        maxi = 0
        for key in cnt:
            if cnt[key] > maxi and key not in banned:
                res = key
                maxi = cnt[key]
        return res