import re

def firstStar(list_seats):
	maxSeat = max(list_seats)

	return int(re.match(r"\d{7}",maxSeat).group(),2) * 8 + int(re.search(r"\d{3}$",maxSeat).group(),2)

def secondStar(list_seats):
	list_seats_b10 = [int(i,2) for i in list_seats[:-1]]

	return sum(range(min(list_seats_b10),max(list_seats_b10)+1)) - sum(list_seats_b10)




with open('input.txt') as file:
	input_list = file.read()


input_list = input_list.replace("B","1")
input_list = input_list.replace("F","0")
input_list = input_list.replace("L","0")
input_list = input_list.replace("R","1")

input_list = input_list.split("\n")

print(firstStar(input_list))
print(secondStar(input_list))