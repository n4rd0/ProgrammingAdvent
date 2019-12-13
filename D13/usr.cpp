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

//This determines where should the padlock move based on the ball position
int determineMove(const std::vector<long> &v) {
    int ballX = -1, padX = -1;

    //We can only exit the for once we know both the ball and pad x coord
    for (int i = 2; i < v.size() && (ballX == -1 || padX == -1); i+=3)
    {
        if (v[i] == 3)
            padX = v[i-2];
        else if (v[i] == 4)
            ballX = v[i-2];
    }

    if (padX > ballX)
        return -1;
    else if (padX < ballX)
        return 1;
    return 0;
}

//It takes the vector by reference, it makes
std::vector<long> compute(std::vector<long> v) {

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
                v[c] = determineMove(buff);
                buff.clear();
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
                std::cout << "ERR" << std::endl;
                return buff; //Something has gone wrong
        }
    }

    end:

    return buff;
}

int parseScore(const std::vector<long> &res) {

    for (int i = 0; i < res.size(); i+=3)
    {
        if (res[i] == -1)
            return res[i+2];
    }

    return 0;
}

void fstStar(const std::vector<long> &v){

    auto vec = compute(v);
    int cnt = 0;
    for (int i = 2; i < vec.size(); i+=3)
    {
        if (vec[i] == 2) cnt++;
    }

    std::cout << "Fst: " << cnt << std::endl;
}

void sndStar(std::vector<long> v){

    v[0] = 2;
    auto gameResult = compute(v);
    std::cout << "Snd: " << parseScore(gameResult) << std::endl;
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