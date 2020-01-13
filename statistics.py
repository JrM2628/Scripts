import math


"""
Calculate N choose R
"""
def ncr(a, b):
	return math.factorial(a) / (math.factorial(b) * math.factorial(a-b))


def problem0():
	sum = 0
	for i in range(35, 81):
		sum += ((50**i) * (math.e ** -50)) / math.factorial(i)
	print(sum)


def problem1():
	for x in range (7):
		for y in range(7):
			if(6-x-y >= 0):
				z = (ncr(8, x) * ncr(10, y) * ncr(12, 6-x-y))/ncr(30,6)
			else:
				z = 0
			print(x, y, z.__round__(5))


def problem2():
	probs = [.1, .2, .3, .25, .15]
	for y in range(5):
		sum = 0
		for x in range(5):
			if x-y >= 0:
				sum += ncr(x,y) * (.7 ** y) * (.3 ** (x-y)) * probs[x]
		print(sum.__round__(4))

problem0()
print("----------------------")
problem1()
print("----------------------")
problem2()