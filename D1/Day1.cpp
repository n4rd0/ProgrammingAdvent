#include "Day1.h"
#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>
#include <vector>
#include <string>

using namespace std;

int D11(vector<int> imput) {

	int fuel = 0;

	for (int i = 0; i < imput.size(); i++) {

		fuel += imput[i] / 3 - 2;
	}
	return fuel;
}

int D12(vector<int> imput) {

	int fuel = 0;
	int temp = 0;

	for (int i = 0; i < imput.size(); i++) {

		temp = imput[i] / 3 - 2;
		fuel = fuel + temp;

		while (temp >= 0) {

			temp = temp / 3 - 2;

			if (temp > 0) fuel = fuel + temp;

		}
	}
	return fuel;
}


int main() {

	std::vector<int> modules;
	ifstream myFile;
	int n;

	myFile.open("imputModulesD1.txt");

	if (!myFile.is_open()) exit(EXIT_FAILURE);

	while (myFile.good()) {

		myFile >> n;
		modules.push_back(n);
	}

	myFile.close();

	cout << "Answer 1 = " << D11(modules) << endl;
	cout << "Answer 1 = " << D12(modules) << endl;

	return 0;
}

