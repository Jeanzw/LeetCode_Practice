# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

#上面的内容其实是相当于已经帮我们写好了的
#若是以tree的结构，其实题目中的例子应该是如下的情况
#t1 = TreeNode{val: 1, left = TreeNode{val: 3, left: TreeNode{val:5, left:None, right:Node}, right: None}, right:TreeNode{val: 2, left:None, right:None}}

#t1.val = 1
#t1.left = TreeNode{val: 3, left: TreeNode{val:5, left:None, right:Node}, right: None}
#t1.right = TreeNode{val: 2, left:None, right:None}
#t1.left.left = TreeNode{val:5, left:None, right:Node}
#t1.left.left.left = None.

class Solution:
    def mergeTrees(self, t1: TreeNode, t2: TreeNode) -> TreeNode:
        #这里我们先讨论例外情况，就是没有左右的情况
        if t1 == None:
            return t2
        if t2 == None:
            return t1 
        #如果t1是空的，那么直接返回t2就好了，如果t2是空的，那么直接返回t1就好了
        t3 = TreeNode(t1.val + t2.val)   #这其实相当于我们重新构造出一个新的t3，这个t3就是root，然后我们的root就是t1的val和t2的val之和
        t3.left = self.mergeTrees(t1.left,t2.left)
        t3.right = self.mergeTrees(t1.right,t2.right)
        return t3