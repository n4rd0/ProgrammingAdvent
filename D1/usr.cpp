#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>

std::vector<int> parse() {
    std::string line;
    std::ifstream last("data.txt");
    std::vector<int> vals;
    vals.clear();
    if (last.is_open()){
        while(getline(last, line)){
            if (line.length() > 1)
                vals.push_back(std::stoi(line));
        }
        last.close();
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}

//Passing the vector as a const reference
void fstStar(const std::vector<int> &v){
    int acc = 0;
    for (std::vector<int>::const_iterator i = v.begin(); i != v.end(); ++i)
        acc += *i / 3 - 2;

    std::cout << "Fst: " << acc << std::endl;
}

void sndStar(const std::vector<int> &v){
    int acc = 0;
    for (std::vector<int>::const_iterator i = v.begin(); i != v.end(); ++i){
        int fuel = *i;
        while (fuel > 6)
            acc += (fuel = fuel / 3 - 2);
    }

    std::cout << "Snd: " << acc << std::endl;
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