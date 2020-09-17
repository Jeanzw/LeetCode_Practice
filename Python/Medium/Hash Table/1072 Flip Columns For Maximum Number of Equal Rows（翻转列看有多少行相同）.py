class Solution:
    def maxEqualRowsAfterFlips(self, matrix):
        cache = collections.defaultdict(int)
        for row in matrix:
            vals = []
            trans = []
            for c in row:
                vals.append(c)
                trans.append(1 - c)
            cache[str(vals)] += 1  #这里其实就是把和原本row一样的给加进这个字典中，原本的list当作字典的key，而和这个key一样的就开始统计数量
            cache[str(trans)] += 1 #这里就是把原本row相反的给加进字典中，生成的list作为key，然后统计这个key的数量
        print(cache)
        return max(cache.values())
#这里的意思其实就是
# [1,0,0,1,0]                                      [0,0,0,0,0]  // all-0s
# [1,0,0,1,0]  after flipping 0-th and 4-th columns[0,0,0,0,0]  // all-0s
# [1,0,1,1,1] -----------------------------------> [0,0,1,0,1]
# [0,1,1,0,1]                                      [1,1,1,1,1]  // all-1s
# [1,0,0,1,1]                                      [0,0,0,0,1]
#这里的情况其实就是，我们一行行去扫，统计和它一样的以及完全相反的，然后在这些数中选择最大的