import fileinput
import re

def policy1(minOcurr, maxOcurr, letter, code):
	return minOcurr <= code.count(letter) <= maxOcurr

def policy2(pos1, pos2, letter, code):
	return (code[pos1-1] == letter) ^ (code[pos2-1] == letter)

inp = [re.split(r":\s|[-\s]", line.rstrip()) for line in fileinput.input()]
inp = [(int(line[0]), int(line[1]), line[2], line[3]) for line in inp]

counterStar1 = 0
counterStar2 = 0
for (arg1, arg2, letter, code) in inp:
	counterStar1 += policy1(arg1, arg2, letter, code)
	counterStar2 += policy2(arg1, arg2, letter, code)

print("Star 1:", counterStar1)
print("Star 2:", counterStar2)
