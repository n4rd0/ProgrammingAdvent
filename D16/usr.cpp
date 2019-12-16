#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <array>


std::vector<int> parse() {

    std::string line;
    std::ifstream last("data.txt");
    std::vector<int> vals;
    vals.clear();

    if (last.is_open()){
        while(getline(last, line)){
            for (const auto &c : line)
                vals.push_back((int)c - '0');
        }
        last.close();
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}

std::vector<int> nextPhase(const std::vector<int> &vals, const std::array<int, 4> &pattern) {

    std::vector<int> res;
    res.resize(vals.size());
    const int vs = vals.size();
    const int ps = pattern.size();

    for (int i = 0; i < vs; ++i)
    {
        int tot = 0;

        for (int j = i; j < vs; ++j)
        {
            int p = pattern[((j+1) / (i+1)) % ps];
            if (p == 0)
                j += i;
            else
                tot += vals[j] * p;
        }

        res[i] = std::abs(tot) % 10;
    }

    return res;
}

std::vector<int> nextPhaseAddFromTheEnd(const std::vector<int> &vals, int start) {

    //This works because the offset is so high that the only numbers we add
    //are *1, the complexity can be improved from O^2 to O if we realize
    //that adding from the back is easier
    std::vector<int> res;
    const int vs = vals.size();
    res.resize(vs);

    int prev = 0;
    for (int i = vs-1; i >= 0; --i)
    {
        res[i] = (prev += vals[i]) % 10;
    }

    return res;
}

//Turn the first 7 digits into its base 10 number
int getOffset(const std::vector<int> &v) {
    int res = 0;
    for (int i = 0; i < 7; ++i)
    {
        res *= 10;
        res += v[i];
    }
    return res;
}

//Trim the first t elements from the vector that would be generated
//by concatenating v with itself 10_000 times
//We can take advantage of this repeating pattern to avoid
//generating the whole vector
std::vector<int> trimBeg(const std::vector<int> &v, int t) {
    std::vector<int> res;
    const int vs = v.size();
    const int virtualSize = vs * 10000;
    res.resize(virtualSize-t);

    for (int i = t; i < virtualSize; ++i)
    {
        res[i-t] = v[i%vs];
    }

    return res;
}

void fstStar(const std::vector<int> &v){

    const std::array<int, 4> pattern = {0, 1, 0, -1};
    std::vector<int> msg = v;

    for (int i = 0; i < 100; ++i)
        msg = nextPhase(msg, pattern);

    //Print the output
    std::cout << "Fst: ";
    for (int i = 0; i < 8; ++i)
        std::cout << msg[i];
    std::cout << std::endl;
}

void sndStar(const std::vector<int> v){

    const int offset = getOffset(v);
    std::vector<int> msg = trimBeg(v, offset);

    for (int i = 0; i < 100; ++i)
        msg = nextPhaseAddFromTheEnd(msg, offset);

    //Print the output
    std::cout << "Snd: ";
    for (int i = 0; i < 8; ++i)
        std::cout << msg[i];
    std::cout << std::endl;
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