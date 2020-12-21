#parse
file = "D3.txt"
full_map = []
line = " "
wide = 31

with open(file,"r") as f:

	while line != "":

			line = f.readline()
			
			if line!="":

				full_map.append(line)

def fstStar(list):
	selected_char = ""
	colum_counter = 0
	res = 0

	for i in range(0,len(list)):
		
		selected_char = list[i][colum_counter%wide]
		colum_counter=colum_counter+3
		
		if selected_char == "#":
			res = res+1
	
	return res

def sndStar(list):
	selected_char = ""
	colum_counter = 0

	res_R1D1 = 0
	res_R5D1 = 0
	res_R7D1 = 0
	res_R1D2 = 0

	#R1 D1

	for i in range(0,len(list)):
			
		selected_char = list[i][colum_counter%wide]
		colum_counter=colum_counter+1
			
		if selected_char == "#":
			res_R1D1 = res_R1D1+1

	colum_counter = 0

	#R5 D1
	for i in range(0,len(list)):
			
		selected_char = list[i][colum_counter%wide]
		colum_counter=colum_counter+5
			
		if selected_char == "#":
			res_R5D1 = res_R5D1+1
	
	colum_counter = 0

	#R7 D1
	for i in range(0,len(list)):
				
		selected_char = list[i][colum_counter%wide]
		colum_counter=colum_counter+7
				
		if selected_char == "#":
			res_R7D1 = res_R7D1+1

	colum_counter = 0
	
	#R1 D2
	i = 0
	while i <= len(list):
		selected_char = list[i][colum_counter%wide]
		colum_counter=colum_counter+1
				
		if selected_char == "#":
			res_R1D2 = res_R1D2+1
		i=i+2	
	colum_counter = 0

	return res_R1D1*fstStar(full_map)*res_R5D1*res_R7D1*res_R1D2

print("First Star Answer = ",fstStar(full_map))
print("Second Star Answer = ",sndStar(full_map))
