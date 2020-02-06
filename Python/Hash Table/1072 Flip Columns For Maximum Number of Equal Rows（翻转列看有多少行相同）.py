class Solution:
    def maxEqualRowsAfterFlips(self, matrix):
        cache = collections.defaultdict(int)
        for row in matrix:
            vals = []
            trans = []
            for c in row:
                vals.append(c)
                trans.append(1 - c)
            cache[str(vals)] += 1
            cache[str(trans)] += 1
        print(cache)
        return max(cache.values())
#这里的意思其实就是
# [1,0,0,1,0]                                      [0,0,0,0,0]  // all-0s
# [1,0,0,1,0]  after flipping 0-th and 4-th rows   [0,0,0,0,0]  // all-0s
# [1,0,1,1,1] -----------------------------------> [0,0,1,0,1]
# [0,1,1,0,1]                                      [1,1,1,1,1]  // all-1s
# [1,0,0,1,1]                                      [0,0,0,0,1]
#这里的情况其实就是，我们一行行去扫，统计和它一样的以及完全相反的，然后在这些数中选择最大的