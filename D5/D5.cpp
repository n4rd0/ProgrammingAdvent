#include <iostream>
#include <map>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>

using namespace std;

std::vector<int> parse() {
	std::vector<int> numbers;
	ifstream myFile;
	char coma;
	int num;
	myFile.open("AdvancedComands.txt");
	while (!myFile.eof()) {
		myFile >> num;
		myFile >> coma;
		numbers.push_back(num);		
	}
	myFile.close();
	return numbers;
}
int firstStar(std::vector<int> numbers) {
	int res = 0;
	bool end = false;
	int n = 0;

	while (!end) {
		switch (numbers[n]) {
		case 1:		numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) + (numbers[numbers[n + 2]]); n += 4; break;
		case 4:		n += 2; break;
		case 3:		numbers[numbers[n + 1]] = 1; n += 2; break;
		case 99:	end = true; res = numbers[n + 1]; break;
		case 2:		numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) * (numbers[numbers[n + 2]]); n += 4; break;
		case 101:	numbers[numbers[n + 3]] = (numbers[n + 1]) + (numbers[numbers[n + 2]]); n += 4; break;
		case 102:	numbers[numbers[n + 3]] = (numbers[n + 1]) * (numbers[numbers[n + 2]]); n += 4;  break;
		case 104:	n += 2; break;
		case 1001:	numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) + (numbers[n + 2]);  n += 4; break;
		case 1101:	numbers[numbers[n + 3]] = (numbers[n + 1]) + (numbers[n + 2]); n += 4; break;
		case 1002:	numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) * (numbers[n + 2]); n += 4; break;
		case 1102:	numbers[numbers[n + 3]] = (numbers[n + 1]) * (numbers[n + 2]); n += 4; break;

		default:	std::cout << "ERROR" << endl; break;
		}
	}
	return res;
}
int sndStar(std::vector<int> numbers) {
	int res = 0;
	bool end = false;
	int n = 0;

	while (!end) {
		switch (numbers[n]) {
		case 1:		numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) + (numbers[numbers[n + 2]]); n += 4; break;
		case 2:		numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) * (numbers[numbers[n + 2]]); n += 4; break;
		case 3:		numbers[numbers[n + 1]] = 5; n += 2; break;
		case 4:		res = numbers[numbers[n + 1]]; n += 2; break;
		case 5:		if (numbers[numbers[n + 1]] != 0) n = numbers[numbers[n + 2]]; else n += 3; break;
		case 6:		if (numbers[numbers[n + 1]] == 0) n = numbers[numbers[n + 2]]; else n += 3; break;
		case 7:		numbers[numbers[n + 1]] < numbers[numbers[n + 2]] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 8:		numbers[numbers[n + 1]] == numbers[numbers[n + 2]] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 99:	end = true; break;
		case 101:	numbers[numbers[n + 3]] = (numbers[n + 1]) + (numbers[numbers[n + 2]]); n += 4; break;
		case 102:	numbers[numbers[n + 3]] = (numbers[n + 1]) * (numbers[numbers[n + 2]]); n += 4;  break;
		case 104:	res = numbers[n + 1]; break;
		case 105:	if (numbers[n + 1] != 0) n = numbers[numbers[n + 2]]; else n += 3; break;
		case 106:	if (numbers[n + 1] == 0) n = numbers[numbers[n + 2]]; else n += 3; break;
		case 107:	numbers[n + 1] < numbers[numbers[n + 2]] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 108:	numbers[n + 1] == numbers[numbers[n + 2]] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 1001:	numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) + (numbers[n + 2]);  n += 4; break;
		case 1101:	numbers[numbers[n + 3]] = (numbers[n + 1]) + (numbers[n + 2]); n += 4; break;
		case 1002:	numbers[numbers[n + 3]] = (numbers[numbers[n + 1]]) * (numbers[n + 2]); n += 4; break;
		case 1102:	numbers[numbers[n + 3]] = (numbers[n + 1]) * (numbers[n + 2]); n += 4; break;
		case 1005:	if (numbers[numbers[n + 1]] != 0)  n = numbers[n + 2]; else n += 3;  break;
		case 1105:	if (numbers[n + 1] != 0) n = numbers[n + 2]; else n += 3; break;
		case 1006:	if (numbers[numbers[n + 1]] == 0) n = numbers[n + 2]; else n += 3; break;
		case 1106:	if (numbers[n + 1] == 0) n = numbers[n + 2]; else n += 3; break;
		case 1007:	numbers[numbers[n + 1]] < numbers[n + 2] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 1107:	numbers[n + 1] < numbers[n + 2] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 1008:  numbers[numbers[n + 1]] == numbers[n + 2] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		case 1108:	numbers[n + 1] == numbers[n + 2] ? numbers[numbers[n + 3]] = 1 : numbers[numbers[n + 3]] = 0; n += 4; break;
		default:	std::cout << "ERROR" << endl; break;
		}
	}
	return res;
}
int main() {
	std::vector<int> test = parse();
	int res = firstStar(test);
	int res2 = sndStar(test);
	cout << "Answer 1 = " << res << endl;
	cout << "Answer 2 = " << res2 << endl;
	return 0;
}
