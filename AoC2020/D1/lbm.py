import fileinput

def star1(inp):
	for i in range(len(inp)-1):
		last = inp.pop()
		for num in inp:
			if num + last == 2020:
				return num*last

def star2(inp):
	for i in range(len(inp)-2, 0, -1):
		last = inp.pop()
		for j in range(i, 0, -1):
			other = inp[j]
			for num in inp[:j]:
				if num + other + last == 2020:
					return num*last*other


inp = [int(line) for line in fileinput.input()]
	
print("Star 1:",star1(inp))
print("Star 2:",star2(inp))