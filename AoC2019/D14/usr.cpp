#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>
#include <cmath>
#include <map>

const long TRILLION = 1000000000000L;

struct Material
{
    std::string name;
    long quantity;
};

struct Reaction
{
    std::vector<Material> from;
    Material to;
};

Material toMat(std::string s) {
    Material mat = {};

    if (s[0] == '>')
        s.erase(s.begin());
    if (s[0] == ' ')
        s.erase(s.begin());

    mat.quantity = std::stol(s);
    s.erase(s.begin(),s.begin()+s.find(' ')+1);

    if (s.back() == ' ')
        s.erase(s.end()-1);

    mat.name = s;

    return mat;
}

std::vector<Reaction> parse() {

    std::string line;
    std::string indvMat;
    std::ifstream last("data.txt");
    std::vector<Reaction> vals;
    vals.clear();

    if (last.is_open()){
        while(getline(last, line)){
            std::vector<Material> from;
            std::stringstream ss(line);
            std::string item;
            getline(ss, item, '=');
            std::stringstream sss(item);
            while (getline(sss, indvMat, ',')){
                from.push_back(toMat(indvMat));
            }
            getline(ss, item, '=');
            Material to = toMat(item);
            Reaction r = {};
            r.from = from;
            r.to = to;
            vals.push_back(r);
        }
        last.close();
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}

long countOres(Material from, std::map<std::string, Reaction> &rs, std::map<std::string, long> leftovers) {

    long tot = 0;
    std::vector<Material> stack;
    stack.push_back(from);

    Material next;
    Reaction react;

    while (!stack.empty()) {
        next = stack.back();
        stack.pop_back();
        if (next.name == "ORE"){
            tot += next.quantity;
            continue;
        }

        react = rs[next.name];
        long want = next.quantity;
        long get = react.to.quantity;
        long ratio = (want % get == 0)? want / get : want / get + 1;

        for (const auto &need : react.from)
        {
            Material toS = need;
            long totNeed = toS.quantity * ratio;

            if (leftovers[need.name] >= totNeed){
                leftovers[need.name] -= totNeed;
                totNeed = 0;
            } else {
                totNeed -= leftovers[need.name];
                leftovers[need.name] = 0;
            }

            toS.quantity = totNeed;
            if (totNeed > 0) {
                bool push = true;
                for (int i = 0; i < stack.size() && push; ++i)
                {
                    if (stack[i].name == need.name){
                        stack[i].quantity += totNeed;
                        push = false;
                    }
                }
                if (push)
                    stack.push_back(toS);
            }
        }

        leftovers[next.name] += ratio * get - want;
    }

    return tot;
}


void fstStar(const std::vector<Reaction> &v){

    std::map<std::string, Reaction> m;
    std::map<std::string, long> leftovers;
    for (const auto &react : v)
    {
        m[react.to.name] = react;
        leftovers[react.to.name] = 0;
    }
    Material want = {};
    want.quantity = 1;
    want.name = "FUEL";

    std::cout << "Fst: " << countOres(want, m, leftovers)<< std::endl;
}

void sndStar(std::vector<Reaction> v){

    std::map<std::string, Reaction> m;
    std::map<std::string, long> leftovers;
    for (const auto &react : v)
    {
        m[react.to.name] = react;
        leftovers[react.to.name] = 0;
    }
    Material want = {};
    want.quantity = 1;
    want.name = "FUEL";

    long lb = TRILLION / countOres(want, m, leftovers);
    long ub = 2 * lb;
    long res, i;
    std::map<long, int> isOver; //The array would be too big and we don't store that many values
    int iter = 0; //This is to ensure it terminates
    int limit = (int)(std::log(ub - lb) / std::log(2)) + 2;

    //Binary search to find the highest just bellow 1 TRILLION
    while (iter < limit) {
        i = (ub + lb) / 2;
        if (isOver[i] == -1) break;
        want.quantity = i;
        res = countOres(want, m, leftovers);

        if (res > TRILLION) {
            isOver[i] = 1;
            ub = i;
        } else {
            lb = i;
            isOver[i] = -1;
            if (isOver[i+1] == 1) break;
        }

        iter++;
    }

    std::cout << "Snd: " << i << std::endl;
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