#parse
file = "D4.txt"
passports = []
valid_passports = []
line = " "
accum = " "

with open(file,"r") as f:

	while line != "":

		line = f.readline()

		if line == "\n":
			passports.append(accum)
			accum = ""

		else:
			accum = accum+line

def fstStar(list):

	for i in range(len(list)):

		temp_text = list[i]
		nice_passport = "byr" in temp_text and "iyr" in temp_text and "eyr" in temp_text and "hgt" in temp_text and "hcl" in temp_text and "ecl" in temp_text and "pid" in temp_text

		if nice_passport:
			valid_passports.append(list[i])	

	return len(valid_passports)

def scndStar(list):
	
	counter = 0
	res = 0

	for i in range(len(valid_passports)):

		for j in range(len(valid_passports[i])):
			
			if valid_passports[i][j:j+3] == "byr":
				birth_year = int(valid_passports[i][j+4:j+8])
				
				if 1920<=birth_year<=2002:
					counter = counter+1
					
			if valid_passports[i][j:j+3] == "iyr":
				issue_year = int(valid_passports[i][j+4:j+8])

				if 2010<=issue_year<=2020:
					counter = counter+1
					
			if valid_passports[i][j:j+3] == "eyr":
				expiration_year = int(valid_passports[i][j+4:j+8])

				if 2020<=expiration_year<=2030:
					counter = counter+1

			if valid_passports[i][j:j+3] == "hgt":
				height = valid_passports[i][j+4:j+9].strip()

				if "cm" in height and len(height) == 5:
					if 150<=int(height[0:3])<= 193:
						
						counter = counter +1

				if "in" in height and len(height) == 4: 
					if 59<=int(height[0:2]) <= 76:

						counter = counter +1

			if valid_passports[i][j:j+3] == "hcl":
				hair_colour = valid_passports[i][j+4:j+11]
				
				if hair_colour[0] == "#" and len(hair_colour) == 7:
					counter = counter+1
			
			if valid_passports[i][j:j+3] == "ecl":
				eye_colour = valid_passports[i][j+4:j+7]

				if eye_colour == "amb" or eye_colour == "blu" or eye_colour == "brn" or eye_colour == "gry" or eye_colour == "grn" or eye_colour == "hzl" or eye_colour == "oth":

					counter = counter+1

			if valid_passports[i][j:j+3] == "pid":
				counter_id = 0
				passport_id = valid_passports[i][j+4:j+14].strip()


				if  passport_id.isnumeric() and len(passport_id) == 9:
					counter = counter + 1 
		
		if counter == 7:
			res = res + 1
		counter = 0
	return res

print("First Star Answer = ",fstStar(passports))
print("Second Star Answer =",scndStar(passports))
