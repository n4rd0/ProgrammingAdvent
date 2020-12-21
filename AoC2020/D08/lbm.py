def star1(inp, i = 0, accum = 0, visited = set()):
	#True means program ended successfully, used in star 2
	if i in visited or i > len(inp):
		return (False, accum)
	elif i == len(inp):
		return (True, accum)
	elif inp[i][instr] == jmp:
		return star1(inp, i + inp[i][val], accum, visited | {i})
	elif inp[i][instr] == acc:
		return star1(inp, i + 1, accum + inp[i][val], visited | {i})
	else:
		return star1(inp, i + 1, accum, visited | {i})

def star2(inp, i = 0):
	#acc is not corrupted
	if inp[i][instr] == acc:
		return star2(inp, i + 1)

	isNop = True if inp[i][instr] == nop else False
	inp[i][instr] = jmp if isNop else nop

	isTerminated, accum = star1(inp)

	if isTerminated:
		return accum
	else:
		inp[i][instr] = nop if isNop else jmp
		return star2(inp, i + 1)

ops = {'jmp' : 0, 'acc' : 1, 'nop' : 2}
jmp, acc, nop, instr, val = 0, 1, 2, 0, 1

with open("input8.txt") as f:
	inp = [line.split(' ') for line in f.read().splitlines()]
	inp = [[ops[instr], int(value)] for (instr, value) in inp]

print("Star 1:",star1(inp)[1])
print("Star 2:",star2(inp))



