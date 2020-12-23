#include <iostream>
#include <vector>
#include <string>
#include <chrono>

void showLL(const std::vector<int> &v)
{
    int current = v[1];
    do {
        std::cout << current;
        current = v[current];
    } while (1 != current);
    std::cout << std::endl;
}

std::vector<int> genVector(const std::vector<int> &v)
{
    std::vector<int> res(v.size()+1);
    res[0] = 0;
    int prev = v[0];
    for (int i = 1; i < v.size(); ++i) {
        res[prev] = v[i];
        prev = v[i];
    }

    res[v[v.size()-1]] = v[0];

    return res;
}

int getDestination(int val, int i, const std::vector<int> &v, const int max)
{
    if (val == 0)
        val = max;

    if (i == val || v[i] == val || v[v[i]] == val)
        return getDestination(val-1, i, v, max);

    return val;
}

void calculate(const std::vector<int> &list, const int iters, const int star)
{
    std::vector<int> v = genVector(list);
    int current = list[0];
    int destination, next, ending;
    int maxVal = v.size()-1;

    for (int i = 0; i < iters; ++i) {
        destination = getDestination(current-1, v[current], v, maxVal);
        next = v[current];
        ending = v[v[v[current]]];

        v[current] = v[ending];
        v[ending] = v[destination];
        v[destination] = next;

        current = v[current];
    }

    if (star == 1) {
        std::cout << "Star1: ";
        showLL(v);
    } else if (star == 2) {
        unsigned long fst = (unsigned long)v[1];
        unsigned long snd = (unsigned long)v[v[1]];
        std::cout << "Star2: " << fst * snd << std::endl;
    }
}

std::vector<int> parseInput(const std::string input)
{
    std::vector<int> v;

    for(char c : input) {
        v.push_back(c - '0');
    }

    return v;
}

void fillVector(std::vector<int> &v)
{
    const int lim = 1000000;
    for (int i = 10; i <= lim; ++i) {
        v.push_back(i);
    }
}

int main(int argc, char const *argv[])
{
    std::string input("362981754");
    std::vector<int> v = parseInput(input);
    auto start = std::chrono::high_resolution_clock::now();
    calculate(v, 100, 1);
    auto endfst = std::chrono::high_resolution_clock::now();
    fillVector(v);
    calculate(v, 10000000, 2);
    auto endsnd = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsedFst = endfst - start;
    std::chrono::duration<double> elapsedSnd = endsnd - endfst;

    std::cout << "Fst took: " << elapsedFst.count() << "; Snd took: " << elapsedSnd.count() << std::endl;
    return 0;
}
