#parse

file = "D1.txt"
numeros_temp = 0
numeros_even = []
numeros_odd = []

with open(file,"r") as f:
	while numeros_temp != "":

			numeros_temp = f.readline()

			if numeros_temp!="":
				numeros_temp = int(numeros_temp)

				if numeros_temp%2 == 0 :
					numeros_even.append(numeros_temp)
				else:
					numeros_odd.append(numeros_temp)

#buscamos dos numeros que sumados den 2020, esto solo puede pasar entrepar y par 1000+1000, impar impar 1997+3, nunca entre par + impar ya que esto siempreda como resultado un impar

def fstStar(even,odd):
	res = 0
	n1 = 0
	n2 = 0

	for i in range(len(even)):
		n1 = even[i]
    
		for j in range(len(even)):
			n2 = even[j]

			if n1 + n2 == 2020:
				res = n1*n2
				return res

	for i in range(len(odd)):
		n1 = odd[i]

		for j in range(len(odd)):
			n2 = odd[j]

			if n1 + n2 == 2020:
				res = n1*n2
				return res

	return res

#buscamos tres numeros que sumados den 2020, esto solo puede pasar entrepar impar impar, par par par 

def sndStar(even,odd):
	res = 0
	n1 = 0
	n2 = 0

	for i in range(len(even)):
		n1 = even[i]

		for j in range(len(even)):
			n2 = even[j]

			for k in range(len(even)):
				n3 = even[k]

				if n1 + n2 +n3== 2020:
					res = n1*n2*n3
					return res

	for i in range(len(even)):
		n1 = even[i]

		for j in range(len(odd)):
			n2 = odd[j]

			for k in range(len(odd)):
				n3 = odd[k]

				if n1 + n2 +n3== 2020:
					res = n1*n2*n3
					return res
	return res

print("First Star Answer = ", fstStar(numeros_pair,numeros_odd))
print("Second Star Answer = ", sndStar(numeros_pair,numeros_odd))
