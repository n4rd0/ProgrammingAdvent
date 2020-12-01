#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>
#include <map>

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

struct Point
{
    int x;
    int y;
};

struct State
{
    std::vector<long> v;
    int index;
    long out1;
    long out2;
    long relBase;
    bool end;
};

const bool operator<(const Point& self, const Point& other) {
    return self.x < other.x || (self.x == other.x && self.y < other.y);
}

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
void compute(State &s, int input) {

    int i = s.index;
    long to, b, c;
    long relBase = s.relBase;
    int twice = 0;
    while (i < s.v.size())
    {
        long instr = s.v[i] % 100;
        long C = (s.v[i] / 100) % 10, B = (s.v[i] / 1000) % 10, A = (s.v[i] / 10000) % 10;

        c = param(s.v, i+1, C, relBase); //This one is used in almost every instr
        //This instructions are common, to avoid code repetition
        if (instr != END && (1LL << (instr-1)) & ALL_INPS)
        {
            b = param(s.v, i+2, B, relBase);
            to = (A == 0)? s.v[i+3] : relBase + s.v[i+3];
            i+=4;
        }

        switch (instr) {
            case ADD: s.v[to] = c + b; break;
            case MULT: s.v[to] = c * b; break;
            case LS: s.v[to] = c <  b; break;
            case EQ: s.v[to] = c == b; break;

            case IN:
                c = (C == 2)? relBase + s.v[i+1] : s.v[i+1];
                s.v[c] = input;
                i+=2;
            break;
            case OUT:
                s.out1 = s.out2;
                s.out2 = c;
                twice++;
                i+=2;
                if (twice == 2) goto end;
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
                s.end = true;
                goto end;
            break;
            default:
                std::cout << "Something wrong" << std::endl;
                return; //Something has gone wrong
        }
    }

    end:
    s.index = i;
    s.relBase = relBase;
    if (i > s.v.size()) s.end = true;
    return;
}

std::map<Point, int> runRobot(std::vector<long> v, int fstMap) {

    v.resize(v.size() * 10);
    Point dirs[4] = {
        (Point) {.x = 0, .y = 1},
        (Point) {.x = 1, .y = 0},
        (Point) {.x = 0, .y = -1},
        (Point) {.x = -1, .y = 0}
    };
    std::map<Point, int> m;

    State s = (State) {};
    s.end = false;
    s.v = v;

    Point pos = (Point) {.x = 0, .y = 0};
    m[pos] = fstMap;
    int dir = 0;

    while (!s.end) {
        compute(s, m[pos]);
        m[pos] = s.out1;
        if (s.out2 == 1)
            dir = (dir+1) % 4;
        else
            dir = (dir+3) % 4;

        pos.x += dirs[dir].x;
        pos.y += dirs[dir].y;
    }

    return m;
}

void draw(std::map<Point, int> &m) {

    int minx = 0, maxx = 0, miny = 0, maxy = 0;

    for (std::map<Point,int>::iterator i = m.begin(); i != m.end(); ++i)
    {
        //If the color is black we ignore it
        if (!i->second) continue;

        if (i->first.y < miny)
            miny = i->first.y;
        else if (i->first.y > maxy)
            maxy = i->first.y;

        if (i->first.x < minx)
            minx = i->first.x;
        else if (i->first.x > maxx)
            maxx = i->first.x;
    }

    for (int i = minx; i <= maxx; ++i)
    {
        Point p = (Point) {.x = i, .y = 0};
        char s[maxy - miny+2];
        for (int j = miny; j <= maxy; ++j)
        {
            p.y = j;
            s[j-miny] = (m[p] == 1)? '#' : ' ';
        }

        s[maxy - miny+1] = '\0';
        std::cout << s << std::endl;
    }
}

void fstStar(const std::vector<long> &v){

    auto m = runRobot(v, 0);
    std::cout << "Fst: " << m.size() << std::endl;
}

void sndStar(const std::vector<long> &v){

    auto m = runRobot(v, 1);
    std::cout << "Snd: input is sideways" << std::endl;
    draw(m);
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
