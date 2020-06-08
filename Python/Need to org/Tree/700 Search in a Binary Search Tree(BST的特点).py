# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def searchBST(self, root: TreeNode, val: int) -> TreeNode:
        #a binary search tree (BST)这里要搞清楚的一个概念就是BST的特点就是，这棵树的left永远是比node要小的，right永远是比node要大的
        #我们先考虑特殊情况：
        if root == None:
            return None
        if root.val == val:
            return root
        if root.val < val:
            return self.searchBST(root.right,val)
        else:
            return self.searchBST(root.left,val)