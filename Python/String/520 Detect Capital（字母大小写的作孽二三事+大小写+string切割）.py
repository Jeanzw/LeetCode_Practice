#我们先生成一个字母表
import string
abc = string.ascii_uppercase   #大写字母表，如果是小写字母表那么就是lowercase
#print(abc)

##print(str.upper())          # 把所有字符中的小写字母转换成大写字母
##print(str.lower())          # 把所有字符中的大写字母转换成小写字母
##print(str.capitalize())     # 把第一个字母转化为大写字母，其余小写
##print(str.title())          # 把每个单词的第一个字母转化为大写，其余小写

s = "FlaG"
if s.upper() == s:
    print(True)
elif s.lower() == s:
    print(True)
elif s.capitalize() == s:
    print(True)
else:
    print(False)




#另一种更快捷的思路是：
    #我们不需要比较第一个字母，我们就比较第二个字母往后的内容，如果全upper()或者lower()之后和原来的内容一样，那么就是对的
print(s[1:].lower() == s[1:] or s.upper() == s)


#还有一种思路是说可以寻找到所有的
class Solution:
	def detectCapitalUse(self, word: str) -> bool:
		word_list = list(word)      # create a list of chars
		if word_list[0].islower():      # if the first character is lower
			return all(char.islower() for char in word_list)        # return true if all other are lower too
		else:
			if all(char.islower() for char in word_list[1:]):       # if the first is upper and rest are lower return True
				return True     
			else:
				return all(char.isupper() for char in word_list)        # if the first is upper as well as all others return True
				# otherwise return False