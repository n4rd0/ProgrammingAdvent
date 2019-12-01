#include <iostream>
#include <cmath>
#include <fstream>
#include <cstdlib>

using namespace std;

int D11(int imput []){

	int fuel = 0;
	
	for(int  i = 0;i<100;i++){
		
		fuel += imput[i]/3-2;
		}
	return fuel;
}

int D12(int imput []){

	int fuel = 0;
	int temp = 0;
	
	for(int  i = 0;i<100;i++){
		
		temp = imput[i]/3-2;
		fuel = fuel + temp;
		
		while(temp>=0){
			
		temp = temp/3-2;	
		
		if(temp>0) fuel = fuel +temp;
		
		}
	}
	return fuel;
}

int main() {

	const int LEN = 100;
	int modules [LEN];
	int test[2] = {100756, 1969} ;
	ifstream myFile;

	myFile.open("imputModulesD1.txt");

	if(!myFile.is_open()) exit(EXIT_FAILURE);
	
	for(int i = 0;i<LEN;i++){
		
		myFile>>modules[i];
		
		} 
		
	myFile.close();
	
	cout<<"Answer 1 = "<<D11(modules)<<endl;
	cout<<"Answer 2 = "<<D12(modules)<<endl;

	return 0;

	}
	
