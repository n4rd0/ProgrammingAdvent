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
    REL,
    END = 99,

    ALL_INPS = 0b11110011,
};

std::vector<long> parse() {
    std::string line;
    std::ifstream last("data.txt");
    std::vector<long> vals;
    vals.clear();
    if (last.is_open()){
        while(getline(last, line)){
            std::stringstream ss(line);
            std::string item;
            while (getline(ss, item, ','))
                vals.push_back(std::stol(item));
        }
        last.close();
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}

const long param(const std::vector<long> &v, int i, int mode, int offset){
    if (mode == 1)
        return v[i];
    else if (mode == 2)
        return v[offset + v[i]];
    else
        return v[v[i]];
}

//It takes the vector by reference, it makes
long compute(std::vector<long> v, long input) {

    v.resize(v.size() * 10);
    long i = 0;
    long to, b, c;
    std::vector<long> buff;
    long relBase = 0;
    while (i < v.size())
    {
        long instr = v[i] % 100;
        long C = (v[i] / 100) % 10, B = (v[i] / 1000) % 10, A = (v[i] / 10000) % 10;

        c = param(v, i+1, C, relBase); //This one is used in almost every instr
        //This instructions are common, to avoid code repetition
        if (instr != END && (1LL << (instr-1)) & ALL_INPS)
        {
            b = param(v, i+2, B, relBase);
            to = (A == 0)? v[i+3] : relBase + v[i+3];
            i+=4;
        }

        switch (instr) {
            case ADD: v[to] = c + b; break;
            case MULT: v[to] = c * b; break;
            case LS: v[to] = c <  b; break;
            case EQ: v[to] = c == b; break;

            case IN:
                c = (C == 2)? relBase + v[i+1] : v[i+1];
                v[c] = input;
                i+=2;
            break;
            case OUT:
                buff.push_back(c);
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

            case REL:
                relBase += c;
                i+=2;
            break;

            case END:
                goto end;
            break;
            default:
                return -1; //Something has gone wrong
        }
    }

    end:
    /*
    //Uncomment this if you want to see all outputs, this isn't needed for any star though
    for (auto o : buff)
    {
        std::cout << o << ", ";
    }
    std::cout << std::endl;
    */
    return buff[buff.size()-1];
}

void fstStar(const std::vector<long> &v){

    std::cout << "Fst: " << compute(v, 1) << std::endl;
}

void sndStar(const std::vector<long> &v){

    std::cout << "Snd: " << compute(v, 2) << std::endl;
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