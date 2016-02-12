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
