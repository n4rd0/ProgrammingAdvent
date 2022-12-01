m,t=0,0
c=[]
i=open("ProgramingAdvent\AoC2022\D1\D1.txt", 'r')
for l in i.readlines():
    if l!="\n":
        t+=int(l)
    else: 
        c.append(int(t))
        if t>m:
            m=t 
        t=0
c.sort()
sum(c[-3:])
