def ValidParenthesis(a):
    cnt = 0
    for i in a:
        if i == "(":
            cnt += 1
        elif i == ")":
            cnt -= 1
        if cnt < 0:
            return False
    return cnt == 0

# 这里的逻辑就是做加减法，当是左括号的时候那么+1，如果是右括号那么是-1
# 我们要保证的是右边的括号不会超过左边的括号，也就是说cnt不会小于0
# 同时在最后要保证右边的括号和左边的括号一样多，也就是cnt = 0