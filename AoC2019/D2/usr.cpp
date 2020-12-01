#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>

const int TARGET = 19690720;

std::vector<int> parse() {
    std::string line;
    std::ifstream last("data.txt");
    std::vector<int> vals;
    vals.clear();
    if (last.is_open()){
        while(getline(last, line)){
            std::stringstream ss(line);
            std::string item;
            while (getline(ss, item, ','))
                vals.push_back(std::stoi(item));
        }
        last.close();
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}

//It takes the vector by reference, it makes
int compute(std::vector<int> v, int noun, int verb) {

    v[1] = noun;
    v[2] = verb;
    for (int i = 0; i < v.size(); i+=4)
    {
        int a = v[v[i+1]];
        int b = v[v[i+2]];
        switch (v[i]) {
            case 1:
                v[v[i+3]] = a + b;
            break;
            case 2:
                v[v[i+3]] = a * b;
            break;
            case 99:
                goto end;
            break;
            default:
                return -1; //Something has gone wrong
        }
    }

    end:
    return v[0];
}

void fstStar(const std::vector<int> &v){

    std::cout << "Fst: " << compute(v, 12, 2) << std::endl;
}

void sndStar(const std::vector<int> &v){

    const int sz = v.size();
    for (int i = 0; i < sz; ++i) {
        //Because both instructions are symmetric we can start at j = i
        for (int j = i; j < sz; ++j) {

            int res = compute(v, i, j);
            if (res == TARGET)
                std::cout << "Snd: " << 100 * i + j << std::endl;
        }
    }
}

int main(){
    const auto v = parse();

    auto start = std::chrono::high_resolution_clock::now();
    fstStar(v);
    auto endfst = std::chrono::high_resolution_clock::now();
    sndStar(v);
    auto endsnd = std::chrono::high_resolution_clock::now();


    std::chrono::duration<double> elapsedFst = endfst - start;
    std::chrono::duration<double> elapsedSnd = endsnd - endfst;

    std::cout << "Fst took: " << elapsedFst.count() << "; Snd took: " << elapsedSnd.count() << std::endl;
}