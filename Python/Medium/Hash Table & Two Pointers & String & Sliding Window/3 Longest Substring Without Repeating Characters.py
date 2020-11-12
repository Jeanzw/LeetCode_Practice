class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        dict = {}
        max_len = start = 0
        for i, v in enumerate(s):
            # print(i,v)
            if v in dict:
                end = dict[v] + 1
                if end > start:
                    start = end
            cur_len = i + 1 - start
            if cur_len > max_len:
                max_len = cur_len
            dict[v] = i
        return max_len
'''
p w w  k  e w
0 1 2  3   4 5

i=0
start = 0
dict = {}
cur_len = 0+1-0 = 1 
max_len = 1
dict = {‘p’: 0}

i=1
start = 0
dict = {‘p’: 0}
cur_len = 1+1-0 = 2
max_len = 2
dict = {‘p’:0, ‘w’: 1}

i=2
start = 0
dict = {‘p’:0, ‘w’: 1}
end = 2+1 = 3
start = 3
cur_len = 2+1-3 = 0
dict = {‘p’:0, ‘w’: 2}

i=3
start = 3
cur_len = 3+1-3 = 1
dict = {‘p’:0, ‘w’: 2, ‘k’: 3}

'''