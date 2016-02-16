#!/usr/bin/python

#working on print
print "doulbe quote"
print 'signle quote'
print r'raw string with \n'
print """multiple
line
string """
print "auto " " string " " concate"
print 3*"1"+"3"


#working on string index
p="python"
print "p[1]  is " + p[1]
print "p[-1] is "+ p[-1]
print "p[1:] is "+ p[1:]
print "p[1:3] is "+ p[1:3]

# working on list
lst = [1,2,3,4]
print lst
print "lst[0] is %d " % lst[0]
print "lst[-1] is %d " % lst[-1]
print "length of lst is %d " % len(lst)

a,b = 0 ,1 
while b<10 :
	print b
	a,b=b,a+b


print "b is ",b 
xx=[-1,0,1,2]
xxx=[]
for x in xx:
	if x<0 : 
		x=0
		xxx.insert(0,"neg")
		print "neg"
	elif x==0 :
		print "zero"
		xxx.insert(0,"zero")
	elif x==1:
		print "single"
		xxx.insert(0,"single")
	else:
		print "more"
		xxx.insert(0,"more")
	
print xxx

for i in range(1,3):
	print i,xx[i]


def ssy () :
	"trying global"
	print "global xx is ",xx
	# as shown below, if I define xx =1, then xx will become a local 
	# variable, which lead to an error in above global case
	#xx=1
	#print "local xx is ",xx

ssy()

f=ssy
print "assign ssy to f , and call f"
f();


def fib(n):
	"returning a fib array"
	result=[]
	a,b=0,1
	while a<n :
		result.append(a)
		a,b=b,a+b
	return result

print fib(20)

def ask (prompt,complain="haha"):
	while True :
		ok=raw_input (prompt)
		if ok in ("y","yes"):
			return True
		elif ok in ("n","no"):
			return False
		else :
			print complain

#ask ("input ")

# default parameter is evaled only once, 
# so it may be different if you modify it
def f1(a,L=[]):
	L.append(a)
	print L

f1(1)
f1(2)
f1(3)

print """
working on tuple
"""
def parrot(k,d):
	for ki in k:
		print ki , d[ki]

k=(1,2,3)
d={1:2,2:3,3:4}
parrot(k,d)

print """
working on lambda
"""
f=lambda x:x+1
print "lambda 1+1 is ",f(1)


f=[3,1,2,5]
f.sort()
print """ sorting 3 1 2 5 is"""
print f

f.sort(reverse=True)
print """rev sorting 3 1 2 5 is"""
print f

print """working on queue with list that is fast"""
from collections import deque
que = deque([1,2,3])
que.append(4)
que.append(5)
print que.popleft()
print que.popleft()
print que

