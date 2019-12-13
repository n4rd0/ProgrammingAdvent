#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>

const int numBodies = 4;

struct Body
{
    int pos[3];
    int vel[3];
};

//mcm and gcd can be expanded to multiple vars using foldls (accumulators)
const long gcd(long a, long b) {
    long d = a % b;
    if (d) return gcd(b, d);
    return b;
}

const long mcm(long x, long y, long z) {
    long mxy = x * y / gcd(x, y);
    long mxyz = z * mxy / gcd(z, mxy);
    return mxyz;
}

std::vector<Body> parse() {

    //TODO: Auto parse
    std::cout << "Write your own inputs, sry too lazy" << std::endl;

    std::vector<Body> vals;
    for (int i = 0; i < numBodies; ++i)
        vals.push_back((Body){});

    //This is the default example
    vals[0].pos[0] = -1;
    vals[0].pos[1] = 0;
    vals[0].pos[2] = 2;

    vals[1].pos[0] = 2;
    vals[1].pos[1] = -10;
    vals[1].pos[2] = -7;

    vals[2].pos[0] = 4;
    vals[2].pos[1] = -8;
    vals[2].pos[2] = 8;

    vals[3].pos[0] = 3;
    vals[3].pos[1] = 5;
    vals[3].pos[2] = -1;

/*
    vals[0].pos[0] = 17;
    vals[0].pos[1] = -9;
    vals[0].pos[2] = 4;

    vals[1].pos[0] = 2;
    vals[1].pos[1] = 2;
    vals[1].pos[2] = -13;

    vals[2].pos[0] = -1;
    vals[2].pos[1] = 5;
    vals[2].pos[2] = -1;

    vals[3].pos[0] = 4;
    vals[3].pos[1] = 7;
    vals[3].pos[2] = -7;
*/

    return vals;
}

int energy(const std::vector<Body> &b) {
    int tot = 0;
    for (int i = 0; i < numBodies; ++i)
    {
        int kin = 0, pot = 0;
        for (int j = 0; j < 3; ++j)
        {
            kin += std::abs(b[i].vel[j]);
            pot += std::abs(b[i].pos[j]);
        }
        tot += kin * pot;
    }

    return tot;
}

void simGrav(std::vector<Body> &b, int axis) {
    for (int i = 0; i < numBodies; ++i)
    {
        for (int j = i+1; j < numBodies; ++j)
        {
            int diff = b[i].pos[axis] - b[j].pos[axis];
            if (diff < 0){
                b[i].vel[axis]++;
                b[j].vel[axis]--;
            } else if (diff > 0) {
                b[i].vel[axis]--;
                b[j].vel[axis]++;
            }
        }
    }
}

void move(std::vector<Body> &b, int axis) {
    for (int i = 0; i < numBodies; ++i)
        b[i].pos[axis] += b[i].vel[axis];
}

//We only need to compare that the positions are equal and that the speeds are 0
bool compEq(std::vector<Body> &b, int init[numBodies], int axis) {
    for (int i = 0; i < numBodies; ++i)
    {
        if (b[i].pos[axis] != init[i] || b[i].vel[axis])
            return false;
    }

    return true;
}

long determinePeriod(std::vector<Body> b, int axis) {

    //We know that the first to repeat will be the initial pos because
    //it is a biyective function, which means that f(a) = b <=> b = f-1(a)
    //so it is impossible to generate a cycle from the startpos and it not
    //being on the cycle itself
    int init[numBodies] = {};
    for (int i = 0; i < numBodies; ++i)
        init[i] = b[i].pos[axis];

    long iter = 0;

    do {
        simGrav(b, axis);
        move(b, axis);

        iter++;
    } while (!compEq(b, init, axis));

    return iter;
}

void fstStar(std::vector<Body> v){

    for (int i = 0; i < 1000; ++i)
    {
        simGrav(v,0);
        simGrav(v,1);
        simGrav(v,2);
        move(v,0);
        move(v,1);
        move(v,2);
    }

    std::cout << "Fst: " << energy(v) << std::endl;
}

void sndStar(std::vector<Body> v){

    //Since the 3 axis are separate we just have to calculate the mcm of the period of each axis
    long m = mcm(determinePeriod(v, 2), determinePeriod(v, 1), determinePeriod(v, 0));
    std::cout << "Snd: " << m << std::endl;
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