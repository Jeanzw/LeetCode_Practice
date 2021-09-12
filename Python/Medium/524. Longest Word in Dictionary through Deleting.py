class Solution:
    def findLongestWord(self, s: str, dictionary: List[str]) -> str:
        dictionary = sorted(dictionary, key= lambda x:(-len(x), x))
        # 上面x:(-len(x), x)的意思是，我们先按照字符长度从大到小进行排序
        # 但是如果两个string的字符长度一致，那么我们就按照它们字符的lexicographical从小到大进行排序

        # 我最开始用的排序是dictionary.sort(key=len,reverse = True)
        # 这个的问题就是它是很纯粹的按照长度排序，然后直接倒过来
        # 比如说['a','b','c']，我们如果用上面的排序就是['c','b','a']，因为按照长度排序其实不改变我们原本的排序，但是我们的reverse立刻就把原来的排序直接倒个个

        print(dictionary)
        for word in dictionary:
            i = 0
            for l in s:
                if i < len(word) and word[i] == l:
                    i += 1
            if i == len(word):
                return word
        return ""



# 上面是排序后的解法，如果我们不排序，解法如下：
class Solution:
    def findLongestWord(self, s: str, dictionary: List[str]) -> str:
        
        #dictionary.sort(key= lambda x: (-len(x),x))

        ans = ''
        
        for d in dictionary:   
            count = 0
            i = j = 0
            while j < len(d) and i < len(s):
                if s[i] == d[j]:
                    j += 1
                    count += 1
                i += 1
            if count == len(d):
                if len(d) > len(ans):
                    ans = d
                if len(d) == len(ans) and d < ans:
                    ans = d
        
        return ans