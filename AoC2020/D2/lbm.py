import fileinput
import re

def star1():
	counter = 0
	for line in inp:
		if line[0] <= line[3].count(line[2]) <= line[1]:
			counter+=1
	return counter

def star2():
	counter = 0
	for line in inp:
		if (line[3][line[0]-1] == line[2]) ^ (line[3][line[1]-1] == line[2]):
			counter+=1
	return counter

inp = [re.split(r":\s|[-\s]", line.rstrip()) for line in fileinput.input()]
inp = [(int(line[0]), int(line[1]), line[2], line[3]) for line in inp]

print("Star 1:", star1())
print("Star 2:", star2())
