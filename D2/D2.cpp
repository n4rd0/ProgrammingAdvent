#include <iostream>
#include <map>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>

using namespace std;

std::vector<int> toVector() {

	std::vector<int> numbers;
	ifstream myFile;
	char coma;
	int num;

	myFile.open("comands.txt");

	while (!myFile.eof()) {
		myFile >> num;
		myFile >> coma;
		numbers.push_back(num);
	}

	myFile.close();

	return numbers;
}

std::vector<int> D21(std::vector<int> numbers){
	bool end = false;

	
	for (int i = 0; i < numbers.size() - 4; i = i + 4)  {
		if (end == true) break;

			switch (numbers[i]) {

			case 1: numbers[numbers[i + 3]] = (numbers[numbers[i + 1]]) + (numbers[numbers[i + 2]]); break;
			case 2: numbers[numbers[i + 3]] = (numbers[numbers[i + 1]]) * (numbers[numbers[i + 2]]); break;
			case 99: end = true; break;
			default: cout << "ERROR" << endl;break;

			}
		}

	return numbers;
}

int D22(std::vector<int> numbers,int wanted) {
	bool found = false;
	int answer = 0;

	for (int i = 0; i < 100; i ++) {
		if (found)break;

		for (int j = 0; j < 100; j++) {

			numbers[1] = i;
			numbers[2] = j;
			std::vector<int> res = D21(numbers);
			cout << res[0]<<endl;

			if (res[0] == wanted) {
				answer = (100 * i) + j; 
				found = true; 
				break;
			}
		}
	}

	return answer;
}

int main() {

	std::vector<int> test = toVector();
	std::vector<int> test2 = toVector();

	test[1] = 12;
	test[2] = 2;
	std::vector<int> res = D21(test);
	int res2 = D22(test2, 19690720);


	cout <<"Answer 1 = "<< res[0] << endl;
	cout << "Answer 2 = " <<res2<<endl;

	return 0;
}
