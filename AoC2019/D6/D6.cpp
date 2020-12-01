#include <iostream>
#include <map>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>
#include <iterator>
#include <algorithm>
#include <map>

using namespace std;

std::vector<std::string> parse() {
	std::vector<std::string> temp;
	std::vector<std::string> orbits;
	std::ifstream myFile;
	std::string comando1;
	std::string def = "";

	myFile.open("orbits.txt");

	while (myFile.good()) {
		getline(myFile, comando1);
		temp.push_back(comando1);
	}
	for (int i = 0; i < temp.size(); i++) {
		def = "";

		for (auto x : temp[i]) {
			if (x == ')') def = "";
			else def = def + x; if (def.size() == 3) orbits.push_back(def);
		}
	}
	myFile.close();
	return orbits;
}
std::map<std::string, int> toMap(std::vector <std::string> nameOfPlanets) {
	std::map<std::string, int> res;
	for (int i = 0; i < nameOfPlanets.size(); i++) {
		res.insert(std::pair<std::string, int>(nameOfPlanets[i], 0));
	}
	return res;
}
std::map<std::string, std::string> toMapString(std::vector <std::string> nameOfPlanets) {
	std::map<string, string> res;
	int i = 0;
	while ( i < nameOfPlanets.size()-1) {
		res.insert(std::pair<std::string, std::string>(nameOfPlanets[i + 1], nameOfPlanets[i]));
		i+=2;
	}
	return res;
}
int fstStar(std::map<std::string,int> mapI, std::vector<std::string>planets) {
	map<string, int> mapCopy = mapI;
	map<string, int> upDated = mapI;
	int res = 0;
	string nameFirst;
	string nameSecond;
	string name;
	int nFirst = 0;
	int n = 1;
	int m = 0;
	bool updates = true;

	while (updates) {
		mapCopy = upDated;
		n = 1;
		while (n < planets.size()) {
			nameFirst = planets[n - 1];
			nameSecond = planets[n];
			nFirst = upDated[nameFirst]; upDated[nameSecond] = nFirst + 1; 
			n += 2;
		}
		m = 0;
		for (int i = 0; i < mapI.size(); i++) {
			name = planets[i];
			if (mapCopy[name] == upDated[name]) m++;
			else break;
			updates = m != upDated.size();
		}
	}
	std::map<string, int>::iterator it= upDated.begin();
	for (it = upDated.begin(); it != upDated.end(); ++it) res += it->second;
	return res;
}
int sndStar(std::map<std::string,std::string> mapI) {
	std::string stop = "COM";
	std::string temp = "YOU";
	std::string intersection = "";
	std::vector<string> SAN_path;
	std::vector<string> YOU_path;

	int nOrbitalStepsYou = 0;
	int nOrbitalStepsSan = 0;

	bool foundCOM = false;
	bool found = false;

	while (!foundCOM) {
		if (mapI[temp] == stop) foundCOM = true;
		else temp = mapI[temp]; YOU_path.push_back(mapI[temp]);
	}
	foundCOM = false;
	temp = "SAN";

	while (!foundCOM) {

		if (mapI[temp] == stop) foundCOM = true; 
	
		else temp = mapI[temp]; SAN_path.push_back(mapI[temp]);
	}

	for (int i = 0; i < YOU_path.size()&&!found;i++) {
		for (int j = 0; j < SAN_path.size();j++) {
			if (YOU_path[i] == SAN_path[j]) {
				intersection = YOU_path[i];
				found = true;
			}
		}
	}
	foundCOM = false;
	stop = intersection;
	temp = "YOU";

	while (!foundCOM) {
		if (mapI[temp] == stop) {
			foundCOM = true;
			nOrbitalStepsYou++;
		}
		else {
			temp = mapI[temp];
			nOrbitalStepsYou++;
		}
	}
	foundCOM = false;
	temp = "SAN";

	while (!foundCOM) {
		if (mapI[temp] == stop) {
			foundCOM = true;
			nOrbitalStepsSan++;
		}
		else {
			temp = mapI[temp]; 
			nOrbitalStepsSan++; 
		}
	}
	return nOrbitalStepsSan+nOrbitalStepsYou-2;
}
int main(){
	vector<string> orbitImput = parse();
	map<string, int> mapNameNumberOrbits = toMap(orbitImput);
	map<string, string> directedOrbits = toMapString(orbitImput);
	int res2 = sndStar(directedOrbits);
	int res = fstStar(mapNameNumberOrbits,orbitImput);
	cout << "Answer 1 = "<<res<<endl;
	cout << "Answer 2 = " << res2 << endl;
}
