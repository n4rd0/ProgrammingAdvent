#include <iostream>
#include <map>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>

using namespace std;

struct point{
int x;
int y;
int step;
};

std::vector<int> parseNums(string name) {
	std::vector<int> numbers;
	ifstream myFile;
	char leter;
	int num;
	char coma;

	myFile.open(name);

	while (!myFile.eof()) {
		myFile >> leter;
		myFile >> num;
		myFile >> coma;
		numbers.push_back(num);
	}

	myFile.close();

	return numbers;
}

std::vector<char> parseLeters(string name) {
	std::vector<char> letters;
	ifstream myFile;
	char leter;
	int num;
	char coma;

	myFile.open(name);

	while (!myFile.eof()) {
		myFile >> leter;
		myFile >> num;
		myFile >> coma;
		letters.push_back(leter);
	}

	myFile.close();

	return letters;
}
std::vector<point> D31_1(std::vector<char> leters, std::vector<int>numbers) {
	std::vector<point> points;
	point lastPoint; lastPoint.x = 0; lastPoint.y = 0; lastPoint.step = 0;

	for (int i = 0; i < numbers.size(); i++) {
		int n = numbers[i];
		while (n > 0) {
			switch (leters[i]) {
			case 'U': lastPoint.y++; lastPoint.step++; break;
			case 'D': lastPoint.y--; lastPoint.step++; break;
			case 'L': lastPoint.x--; lastPoint.step++; break;
			default:  lastPoint.x++; lastPoint.step++; break;

			}
			points.push_back(lastPoint);

			n--;
		}
	}
	
	return points;
}

std::vector<point> D31_2(vector<point> wire1, vector<point> wire2) {
	std::vector<point> repeated;

	for (int i = 0; i < wire1.size(); i++) {
		point search = wire1[i];

		for (int j = 0; j < wire2.size(); j++) {
			int y = wire2[j].y;
			int x = wire2[j].x;

			if (x == search.x && y == search.y) {
				repeated.push_back(search);
				search.step += wire2[j].step;
				cout << search.x << " " << search.y<<" "<<search.step<< endl;
			}
		}
	}

	return repeated;
}

point D31_3(vector<point> repeated) {
	point res = repeated[0];

	for (int i = 1; i < repeated.size(); i++) {
		if ((abs(res.x) + abs(res.y)) > (abs(repeated[i].x) + abs(repeated[i].y))) res = repeated[i]; cout << res.x<<" " << endl;
	}

	return res;
}

int D32_1(vector<point> repeated) {
	point res = repeated[0];
	int minStep = res.step;

	for (int i = 1; i < repeated.size(); i++) {
		if ((repeated[i].step) < (minStep)) minStep = repeated[i].step; cout << res.step << endl;
	}

	return minStep;
}

int main() {
	std::vector <char> letersWire1 = parseLeters("wire1.txt");
	std::vector <char> letersWire2 = parseLeters("wire2.txt");

	std::vector <int> numsWire1 = parseNums("wire1.txt");
	std::vector <int> numsWire2 = parseNums("wire2.txt");

	std::vector<point> pointsWire1 = D31_1(letersWire1, numsWire1);
	std::vector<point> pointsWire2 = D31_1(letersWire2, numsWire2);
	std::vector<point> repeatedPoints = D31_2(pointsWire1, pointsWire2);
	point answer = D31_3(repeatedPoints);
	int answer2= D32_1(repeatedPoints);

	cout << "Answer 1 = "<<abs(answer.x) + abs(answer.y) << endl;
	cout << "Answer 2 = " << answer2 << endl;
}
