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

struct State
{
    std::vector<int> v;
    int index;
    int out;
    bool end;
};

const bool isValid(int n, const int start) {

    bool arr[5] = {false};
    for (int i = 0; i < 5; ++i)
    {
        int mod = n%10 - start;
        if (mod < 0 || mod > 4)
            return false;
        arr[mod] = true;
        n /= 10;
    }

    for (int i = 0; i < 5; ++i)
    {
        if (!arr[i]) return false;
    }

    return true;
}

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


void compute(State& prev, int phase, int out) {

    int i = prev.index;
    int to, b, c;
    auto& v = prev.v; //This is basically renaming the var
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
                v[v[i+1]] = prev.out == 0? phase : out;
                phase = out;
                i+=2;
            break;
            case OUT:
                c = (C == 1)? v[i+1] : v[v[i+1]];
                i+=2;
                prev.index = i;
                prev.out = c;
                return;
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
                std::cout << "ERR" << std::endl;
                return; //Something has gone wrong
        }
    }

    end:
    prev.end = true;

    return;
}

int loop(const std::vector<int> &v, int start) {

    int max = 0;
    int limit = (start + 5) * 10000;
    for (int i = 1000 * start; i < limit; ++i)
    {
        if (!isValid(i, start)) continue;
        int e = i % 10, d = i / 10 % 10, c = i / 100 % 10, b = i / 1000 % 10, a = i / 10000 % 10;
        State sa = (State) {.v = v, .index = 0, .out = 0, .end = false};
        State sb = (State) {.v = v, .index = 0, .out = 0, .end = false};
        State sc = (State) {.v = v, .index = 0, .out = 0, .end = false};
        State sd = (State) {.v = v, .index = 0, .out = 0, .end = false};
        State se = (State) {.v = v, .index = 0, .out = 0, .end = false};

        while (!se.end){

            compute(sa, a, se.out);
            compute(sb, b, sa.out);
            compute(sc, c, sb.out);
            compute(sd, d, sc.out);
            compute(se, e, sd.out);
        }

        if (se.out > max)
            max = se.out;
    }

    return max;
}

void fstStar(const std::vector<int> &v){

    std::cout << "Fst: " << loop(v, 0) <<  std::endl;
}

void sndStar(const std::vector<int> &v){

    std::cout << "Snd: " << loop(v, 5) <<  std::endl;
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