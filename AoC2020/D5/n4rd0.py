#parse
file = "D5.txt"
seats = []
line = " "

with open(file,"r") as f:

	while line != "":

		line = f.readline()
		seats.append(line)

def Answer(list):
	max_code = 0
	code_list = []

	for i in range(len(list)-1):

		rows = list[i][0:7].replace("F","0").replace("B","1")
		row_number = int(rows,2)

		colum = list[i][7:].replace("L","0").replace("R","1")
		colum_number = int(colum,2)

		code_list.append(row_number*8 + colum_number)

		if row_number*8 + colum_number > max_code:
			max_code = row_number*8 + colum_number

	code_list.sort()

	for i in range(len(code_list)-1):

		if code_list[i] + 2 == code_list[i+1]:
			res = code_list[i] + 1 

	print("First Star Answer = ", max_code)
	print("Second Star Answer = ", res)

Answer(seats)
