from itertools import permutations

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
	
def compute(input1,input2,inp, pos):
	instruction = [add,multiply,inputNumber,outputNumber,jumpIfTrue,jumpIfFalse,lessThan,equals]
	increase = {1:4, 2:4, 3:2, 4:2, 7:4, 8:4}
	i = pos
	output=0.5
	while inp[i] != 99:
		modes, instr = divmod(inp[i],100)
		if instr == 3:
			if i==0:
				op = instruction[instr-1](input1, inp, i)
			else:
				op = instruction[instr-1](input2, inp, i)
		else:
			op = instruction[instr-1](getModesList(modes), inp, i)
		if instr == 5 or instr == 6:
			i = op
		else:
			if instr == 4:
				output=inp[op]
				break
			else:
				inp[op[1]] = op[0]
			i+=increase[instr]
	return (output, i+2)

def getInput():
	with open('input.txt') as f:
		return [int(a) for a in f.read().split(',')]
		
def star1():
	inp=getInput()
	phases=list(permutations([0,1,2,3,4]))
	maxVal=0
	for a in phases:
		actInp=0
		for phase in a:
			inpp=inp.copy()
			actInp=compute(phase,actInp,inpp,0)[0]
		if actInp > maxVal:
			maxVal=actInp
	return maxVal
	
def star2():
	inp=getInput()
	phases=list(permutations([5,6,7,8,9]))
	maxVal=0
	inpp=inp.copy()
	for a in phases:
		actInp=0
		states=[]
		pos=[]
		for i in range(5):
			inpp=inp.copy()
			actData= compute(a[i],actInp,inpp,0)
			actInp=actData[0]
			states.append(inpp)
			pos.append(actData[1])
		i=0
		while actInp != 0.5:
			output=actInp
			actData=compute(actInp,actInp,states[i],pos[i])
			actInp=actData[0]
			pos[i]=actData[1]
			i=(i+1)%5
		if output > maxVal:
			maxVal=output
	return maxVal

print('Star 1:',star1())
print('Star 2:',star2())