inp={a[4:7] : a[:3] for a in open('input.txt').readlines()}

#Part 1

def numOrbits():
	
	cont=0
	
	for a in inp:
		
		plan=a
		
		while inp[plan]!='COM':
			
			cont+=1
			plan=inp[plan]
			
		cont+=1
	
	return cont

#Part 2

def shortestPath():
	
	you=inp['YOU']
	san=inp['SAN']	
	
	wayYou={you:0}
	waySan={san:0}
	
	setYou=set([you])
	setSan=set([san])
	
	i=1
	
	while not bool(setYou.intersection(setSan)):
		
		if you in inp:
			
			you=inp[you]
			setYou.add(you)
			wayYou[you]=i
			
		if san in inp:
			
			san=inp[san]
			setSan.add(san)
			waySan[san]=i
			
		i+=1
	
	inters= list(setYou.intersection(setSan))
	
	return wayYou[inters[0]] + waySan[inters[0]]

#Solutions

print('Star 1:', numOrbits())
print('Star 2:', shortestPath())