def star1(inp):
	for num in inp:
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

with open("input1.txt") as f:
	inp = [int(line) for line in f.read().splitlines()]
	f.close()
	
print("Star 1:",star1(inp))
print("Star 2:",star2(inp))