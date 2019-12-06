inp={a[4:7] : a[:3] for a in open('input.txt').readlines()}
cont=0

for a in inp:
	plan=a
	while inp[plan]!='COM':
		cont+=1
		plan=inp[plan]
	cont+=1
	
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
print(cont) #sol1
print(wayYou[inters[0]] + waySan[inters[0]]) #sol2