#parse
file = "D2.txt"
passwords = []
password_temp = " "

with open(file,"r") as f:

	while password_temp != "":

			password_temp = f.readline()
			
			if password_temp!="":

				passwords.append(password_temp)


def fstStar (list):

	res = 0
	
	for i in range(len(list)):

		lower_range = 0
		upper_range = 0
		character = ""
		counter = 0
		j = 0
		k = 0
		valid = False

		while(list[i][j] != "-"):

			j=j+1

		lower_range = int(list[i][0:j])
		j=j+1

		while(list[i][j+k] != " "):

			k=k+1

		upper_range = int(list[i][j:j+k])
		k = k+1

		character = list[i][j+k]
		code = list[i][j+k+2:len(list[i])]

		for i in range(len(code)):

			if code[i] == character:
				counter = counter+1

		if counter <= upper_range and counter >= lower_range:
			res = res+1
			valid = True

	return res

def sndStar (list):

	res = 0
	
	for i in range(len(list)):

		lower_range = 0
		upper_range = 0
		character = ""
		counter = 0
		j = 0
		k = 0
		valid = False

		while(list[i][j] != "-"):

			j=j+1

		lower_range = int(list[i][0:j])
		j=j+1

		while(list[i][j+k] != " "):

			k=k+1

		upper_range = int(list[i][j:j+k])
		k = k+1

		character = list[i][j+k]
		code = list[i][j+k+2:len(list[i])]
		
		if (code[lower_range] == character or code[upper_range] == character) and (code[lower_range] != code[upper_range]): 

			res = res+1
			valid = True

	return res

print("First Star Answer = ",fstStar(passwords))
print("Second Star Answer = ",sndStar(passwords))
