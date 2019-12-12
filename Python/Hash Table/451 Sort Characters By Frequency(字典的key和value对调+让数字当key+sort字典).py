class Solution:
    def frequencySort(self, s: str) -> str:
        from collections import Counter
        cnt = Counter(s)
        print(cnt)
        #我们可以另外弄一个新的dic，然后让数字做key，这样子我们就可以排序了
        freq_dict = collections.defaultdict(list)
        #https://www.cnblogs.com/herbert/archive/2013/01/09/2852843.html
        for key,val in cnt.items():
            print(key,val)
            freq_dict[val].append(key)
        print(freq_dict)
        freq_sorted_key = sorted(freq_dict.keys(),reverse = True)   #这个时候我们就按照了key进行了排列
        print(freq_sorted_key)

        res = []
        for k in freq_sorted_key:
            chars = freq_dict[k]
            for c in chars:  #因为这里对应的key可能有多个value（虽然这些value都是在一个list里面）
                for _ in range(k):  #这里其实只是想要统计个数而已
                    res.append(c)
        return ''.join(res)