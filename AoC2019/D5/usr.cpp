#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>

enum INST
{
    ADD = 1,
    MULT,
    IN,
    OUT,
    JMP_TRU,
    JMP_FLS,
    LS,
    EQ,
    END = 99,
};

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
int compute(std::vector<int> v, int input) {

    int i = 0;
    int to, b, c;
    int buffer = 0;
    while (i < v.size())
    {
        int instr = v[i] % 100;
        int C = (v[i] / 100) % 10, B = (v[i] / 1000) % 10;

        //This instructions are common, to avoid code repetition
        if (instr != 3 && instr != 4 && instr != 99)
        {
            b = (B == 1)? v[i+2] : v[v[i+2]];
            c = (C == 1)? v[i+1] : v[v[i+1]];
            to = v[i+3];
            i+=4;
        }

        switch (instr) {
            case ADD: v[to] = c + b; break;
            case MULT: v[to] = c * b; break;
            case LS: v[to] = c <  b; break;
            case EQ: v[to] = c == b; break;

            case IN:
                v[v[i+1]] = input;
                i+=2;
            break;
            case OUT:
                c = (C == 1)? v[i+1] : v[v[i+1]];
                buffer = c;
                i+=2;
            break;

            case JMP_TRU:
                if (c != 0) i = b;
                else i--; //I already increase it by 4, so now reduce it once
            break;
            case JMP_FLS:
                if (c == 0) i = b;
                else i--;
            break;

            case END:
                goto end;
            break;
            default:
                return -1; //Something has gone wrong
        }
    }

    end:
    return buffer;
}

void fstStar(const std::vector<int> &v){

    std::cout << "Fst: " << compute(v, 1) << std::endl;
}

void sndStar(const std::vector<int> &v){

    std::cout << "Snd: " << compute(v, 5) << std::endl;
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