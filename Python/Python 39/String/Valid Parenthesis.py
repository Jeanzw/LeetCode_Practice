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