# 这道题的思路其实很简单：
# 找到没有重复的单词，构成新的list
# 扫原本的string
# 一旦扫到了list里面的内容，停止返回它，否则返回-1


#我的思路其实就是：
#将string计数，选择values = 1的key，然后组成一个list
#我们去扫原来的string，如果里面的values在这个list里面，那么就是它了，如果不在继续扫
#为了找出第一个，那么我们就要让一旦找到，那么就跳出循环
from collections import Counter
s = "loveleetcode"
dic = Counter(s)
print(dic)
new_list = []
for key in dic:
    if dic[key] == 1:
        new_list.append(key)
#print(new_list)

for i in range(len(s)):
    #print(s[i])
    if s[i] in new_list:
        print(i)
        break
    else:
        continue
print(-1)



#其他思路：加减法的思路
#dic就相当于是我们要把出现的字母和其对应的index存到字典中去
#seen相当于我们要找不重复的字母
#我们去扫string，利用enumerate抽出其中的index和values，将这个index和对应values放入到dic里面去
#如果values不在set里面，那么就加入进set，说明是第一次出现，如果在的话，那么我们就要在dic里面删除这个key，因为说明已经存在了
class Solution:
    def firstUniqChar(self, s):
        d = {}
        seen = set()
        for idx, c in enumerate(s):
            if c not in seen:
                d[c] = idx
                seen.add(c)
            elif c in d:
                del d[c]
        return min(d.values()) if d else -1  


class Solution:
	def firstUniqChar(self, s: str) -> int:
		"""
		Counter is the fastest way to count occurrences. It creates Counter object simillar to dictionary.
		key is an item from a string and value is the number of occurrences.
		It's enough to return index of key with value 1.
		If there isn't such key, it means there's no unique character so return -1.
		"""
		for key, value in Counter(s).items():
                    #dic.items()跳出来的是：
                    #dict_items([('l', 2), ('o', 2), ('v', 1), ('e', 4), ('t', 1), ('c', 1), ('d', 1)])
			if value == 1: 
                return(s.index(key))  
		return -1
#了解一下：counter的计数是按照字母出现顺序来进行计数的
