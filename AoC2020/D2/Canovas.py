import re

def getElements(line):
	char = line[1][0]
	lower_number = int(re.match(r"\w+",line[0]).group())
	upper_number = int(re.search(r"\w+$",line[0]).group())
	password = line[-1]
	return char, lower_number, upper_number, password

def firstStar(passwordList):
	passwordList_copy = passwordList[:]
	valid_passwords = 0

	while(len(passwordList_copy) > 0):
		line = passwordList_copy.pop().split()
		char_rep, min_rep, max_rep, password = getElements(line)
		rep_counter = 0 

		for char in password:
			if(char == char_rep):
				rep_counter += 1

		if min_rep <= rep_counter <= max_rep:
			valid_passwords += 1
	return valid_passwords

def secondStar(passwordList):
	passwordList_copy = passwordList[:]
	valid_passwords = 0

	while(len(passwordList_copy) > 0):
		line = passwordList_copy.pop().split()
		char, first_pos, second_pos, password = getElements(line)

		if((password[first_pos-1] == char)  ^ (password[second_pos-1] == char)):
			valid_passwords +=1

	return valid_passwords


with open('input.txt') as file:
	input_list = file.readlines()

print(firstStar(input_list))
print(secondStar(input_list))



