'''
 Definition for singly-linked list.
 class ListNode(object):
     def __init__(self, x):
         self.val = x
         self.next = None
 l1 = {val: 2, next: {val:4, next:{val:3, next: None}}}

head = {val: -1, next: {val: 7, next:None}}
head = {val: 7, next: {val: 0, next:None}}
head = {val: 0, next:{val: 8, next:None}}
head ={val: 8, next:None}'''

class Solution(object):
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        prevHead = head = ListNode(-1)
        carry = 0
        while l1 != None or l2 !=None or carry:
            val = carry
            if l1 != None:
                val += l1.val
                l1 = l1.next
            if l2 != None:
                val += l2.val
                l2 = l2.next
            head.next = ListNode(val%10)
            carry = val/10
            head = head.next
        return prevHead.next
