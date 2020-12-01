def getModesList(modes):
	intModes = []
	for i in range(3):
		modes, mod = divmod(modes, 10)
		intModes.append(mod)
	return intModes

def getModePos(mode, pos, inp):
	if mode==0:
		return inp[pos]
	return pos

def add(modes, inp, pos):
	return (inp[getModePos(modes[0],pos+1,inp)] + inp[getModePos(modes[1],pos+2,inp)], inp[pos+3])

def multiply(modes, inp, pos):
	return (inp[getModePos(modes[0],pos+1,inp)] * inp[getModePos(modes[1],pos+2,inp)], inp[pos+3])

def inputNumber(inputNumber, inp, pos):
	return (inputNumber, inp[pos+1])

def outputNumber(modes, inp, pos):
	return getModePos(modes[0], pos+1, inp)

def jumpIfTrue(modes, inp, pos):
	if inp[getModePos(modes[0],pos+1,inp)] != 0:
		return inp[getModePos(modes[1],pos+2,inp)]
	return pos+3

def jumpIfFalse(modes, inp, pos):
	if inp[getModePos(modes[0],pos+1,inp)] == 0:
		return inp[getModePos(modes[1],pos+2,inp)]
	return pos+3

def lessThan(modes, inp, pos):
	if inp[getModePos(modes[0],pos+1,inp)] < inp[getModePos(modes[1],pos+2,inp)]:
		return (1, inp[pos+3])
	return (0, inp[pos+3])

def equals(modes, inp, pos):
	if inp[getModePos(modes[0],pos+1,inp)] == inp[getModePos(modes[1],pos+2,inp)]:
		return (1, inp[pos+3])
	return (0, inp[pos+3])
	
def compute():
	inpp=[int(a) for a in open('input05.txt').read().split(',')]
	instruction = {1: add, 2: multiply, 3: inputNumber, 4: outputNumber, \
					5: jumpIfTrue, 6: jumpIfFalse, 7: lessThan, 8: equals}
	increase = {1:4, 2:4, 3:2, 4:2, 7:4, 8:4}
	inputStars = [1,5]
	for j in range(2):
		inp = inpp.copy()
		i = 0
		while inp[i] != 99:
			modes, instr = divmod(inp[i],100)
			if instr == 3:
				op = instruction[instr](inputStars[j], inp, i)
			else:
				op = instruction[instr](getModesList(modes), inp, i)
			if instr == 5 or instr == 6:
				i = op
			else:
				if instr == 4:
					if inp[op] != 0:
						print('Star',j+1,':',inp[op])
				else:
					inp[op[1]] = op[0]
				i+=increase[instr]

compute()