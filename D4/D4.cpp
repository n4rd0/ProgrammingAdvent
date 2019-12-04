#include <iostream>
#include <vector>

using namespace std;

bool firstStarCondition(vector<int> temp) {
	return (temp[0] == temp[1] || temp[1] == temp[2] || temp[2] == temp[3] || temp[3] == temp[4] || temp[4] == temp[5]);
}

bool secondStarCondition(vector<int> temp) {
	bool res = false;

	if (temp[0] == temp[1] && temp[0] != temp[2] && temp[0] != temp[3] && temp[0] != temp[4] && temp[0] != temp[5]) res = true;
	else if (temp[1] == temp[2] && temp[1] != temp[0] && temp[1] != temp[3] && temp[1] != temp[4] && temp[1] != temp[5]) res = true;
	else if (temp[2] == temp[3] && temp[2] != temp[0] && temp[2] != temp[1] && temp[2] != temp[4] && temp[2] != temp[5]) res = true;
	else if (temp[3] == temp[4] && temp[3] != temp[0] && temp[3] != temp[1] && temp[3] != temp[2] && temp[3] != temp[5]) res = true;
	else if (temp[4] == temp[5] && temp[4] != temp[0] && temp[4] != temp[1] && temp[4] != temp[2] && temp[4] != temp[3]) res = true;
	else if (temp[3] == temp[4] && temp[3] != temp[0] && temp[3] != temp[1] && temp[3] != temp[2] && temp[3] != temp[5]) res = true;

	else if (temp[0] == temp[1] && temp[4] == temp[5] && temp[1] != temp[2] && temp[3] != temp[4] && temp[2] != temp[3]) res = true;
	else if (temp[0] == temp[1] && temp[2] == temp[3] && temp[1] != temp[2] && temp[3] != temp[4] && temp[4] != temp[5]) res = true;
	else if (temp[0] == temp[1] && temp[3] == temp[4] && temp[1] != temp[2] && temp[3] != temp[2] && temp[3] != temp[5]) res = true;
	else if (temp[0] == temp[1] && temp[2] == temp[3] && temp[1] != temp[2] && temp[3] != temp[4] && temp[4] != temp[5]) res = true;
	else if (temp[1] == temp[2] && temp[4] == temp[3] && temp[2] != temp[3] && temp[0] != temp[1] && temp[4] != temp[5]) res = true;
	else if (temp[2] == temp[1] && temp[4] == temp[5] && temp[1] != temp[0] && temp[3] != temp[1] && temp[4] != temp[3]) res = true;
	else if (temp[2] == temp[3] && temp[4] == temp[5] && temp[1] != temp[0] && temp[3] != temp[2] && temp[3] != temp[4]) res = true;

	else if (temp[0] == temp[1] && temp[1] == temp[2] && temp[2] == temp[3] && temp[3] != temp[4] && temp[4] == temp[5]) res = true;
	
	return res;
}

int generateNums() {

	vector<vector<int>> res;
	vector<vector<int>> res2;

	vector<int> temp;
	int num = 0;

	temp.push_back(0);
	temp.push_back(0);
	temp.push_back(0);
	temp.push_back(0);
	temp.push_back(0);
	temp.push_back(0);
	


	for (int i = 2; i <= 7; i++) {
		num = 0;
		temp[0] = i;
		for (int j = i; j <= 9; j++) {
		
			temp[1] = j;
			for (int k = j; k <= 9; k++) {

				temp[2] = k;
				for (int n = k; n <= 9; n++) {

					temp[3] = n;
					for (int m = n; m <= 9; m++) {

						temp[4] = m;
						for (int l = m; l <= 9; l++) {

							temp[5] = l;

							num = temp[0] * 100000 + temp[1] * 10000 + temp[2] * 1000 + temp[3] * 100 + temp[4] * 10 + temp[5] * 1;
							bool inRange = num < 790572 && num>245182;
							if (inRange && firstStarCondition(temp)) {
								res.push_back(temp);
							}

							if (inRange && secondStarCondition(temp)) {
								res2.push_back(temp);
							}
						}
					}
				}
			}
		}
	}

	cout <<"Answer 1 = "<< res.size() << endl;
	cout <<"Answer 2=  "<<res2.size() << endl;

	return res.size();
}

int main() {
	
	int answer = generateNums();
	return 0;
}

