def getInput():
	with open('input10.txt') as f:
		asteroids = []
		lines = [line for line in f.read().split('\n')]
		lines.pop()
		for j in range(len(lines)):
			for i in range(len(lines[0])):
				if lines[j][i]=='#':
					asteroids.append((i,j))
		return asteroids

def getBestAsteroid():
	coords = getInput()
	currentMax = 0
	for i in range(len(coords)):
		act = coords[i]
		without = coords[:i] + coords[i+1:]
		keepSlopes=set()
		for a in without:
			if a[0]==act[0] and a[1]>act[1]:
				keepSlopes.add(1)
			if a[0]==act[0] and a[1]<act[1]:
				keepSlopes.add(2)
			if a[0]>act[0] and a[1]==act[1]:
				keepSlopes.add(3)
			if a[0]<act[0] and a[1]==act[1]:
				keepSlopes.add(4)		
		without=[a for a in without if a[0]!=act[0] and a[1]!=act[1]]
		checkUp = [a for a in without if a[1]>act[1]]
		checkDown = [a for a in without if a[1]<act[1]]
		seenSlopes=set()
		for a in checkUp:
			currSlope= (a[1]-act[1])/(a[0]-act[0])
			seenSlopes.add(currSlope)
		cont= len(seenSlopes) + len(keepSlopes)
		seenSlopes=set()
		for a in checkDown:
			currSlope= (a[1]-act[1])/(a[0]-act[0])
			seenSlopes.add(currSlope)
		cont+= len(seenSlopes)
		if cont > currentMax:
			currentMax=cont
	return currentMax

def vaporizeAsteroids():
	inp = getInput()
	coords = inp[:170] + inp[171:]
	act = (23,19)
	posSlopes = [{},{},{},{}]
	for a in coords:
		if a[0]==act[0] and a[1]>act[1]:
			posSlopes[2][a] = -100
		elif a[0]==act[0] and a[1]<act[1]:
			posSlopes[0][a] = 100
		elif a[0]>act[0] and a[1]==act[1]:
			posSlopes[1][a] = 0
		elif a[0]<act[0] and a[1]==act[1]:
			posSlopes[3][a] = 0
		elif a[0] > act[0]:
			posSlopes[1][a] = (act[1]-a[1])/(a[0]-act[0])
		elif a[0] < act[0]:
			posSlopes[3][a] = (act[1]-a[1])/(a[0]-act[0])
	sortedSlopes = [list(sorted(posSlopes[i].values(), reverse=True)) for i in range(4)]
	finalSlopes = [{},{},{},{}]
	for i in range(4):
		for a in sortedSlopes[i]:
			actSlope = []
			for b in posSlopes[i]:
				if posSlopes[i][b] == a:
					actSlope.append(b)
			if i!=2 and i!=3:
				actSlope.sort(key = lambda x: (x[0],-x[1]))
			if i==3:
				actSlope.sort(key = lambda x: (-x[0],-x[1]))
			for b in actSlope:
				finalSlopes[i][b] = a
	sortedSlopes = [list(dict.fromkeys(sortedSlopes[i])) for i in range(4)]
	i = 0
	asts = 0
	vaporizedAsts = []
	while asts <= 200:
		actSlopes = sortedSlopes[i]
		actPosSlopes = finalSlopes[i]
		for a in actSlopes:
			for b in actPosSlopes:
				if actPosSlopes[b] == a:
					asts+=1
					if asts == 200:
						print('Star 2:', (100*b[0] + b[1]))
					vaporizedAsts.append(b)
					del(finalSlopes[i][b])
					break
		i = (i+1)%4
	return vaporizedAsts	

print('Star 1:', getBestAsteroid())
vaporizeAsteroids()