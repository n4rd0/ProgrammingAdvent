#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>
#include <map>

struct Point
{
    int x;
    int y;
};

const bool operator<(const Point& self, const Point& other) {
    return self.x < other.x || (self.x == other.x && self.y < other.y);
}

const int manhDist(const Point& p) {
    return std::abs(p.x) + std::abs(p.y);
}

std::vector<Point> parse(const int lnum) {
    std::string line;
    std::ifstream last("data.txt");
    std::vector<Point> vals;
    vals.clear();
    if (last.is_open()){
        getline(last, line);
        std::string item;
        if (lnum == 1) //We want the second line
            getline(last, line);

        std::stringstream ss(line);
        Point p = (Point) {.x = 0, .y = 0};
        while (getline(ss, item, ',')) {
            char dir = item[0];
            item.erase(item.begin());
            for (int num = std::stoi(item); num > 0; --num) {
                switch (dir) {
                    case 'U': p.y++; break;
                    case 'D': p.y--; break;
                    case 'R': p.x++; break;
                    case 'L': p.x--; break;
                    default:
                        std::runtime_error("ERROR parsing char " + dir);
                }
                vals.push_back(p);     
            }
        }

        last.close();
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}


void fstStar(const std::vector<Point> &p1, const std::vector<Point> &p2){

    std::map<Point, bool> set;

    for (Point p : p1) {
        set[p] = true;
    }

    int min = 99999;
    for (Point p : p2) {
        if (set[p] && manhDist(p) < min)
            min = manhDist(p);
    }

    std::cout << "Fst: " << min << std::endl;
}

void sndStar(const std::vector<Point> &p1, const std::vector<Point> &p2){

    std::map<Point, int> path;

    int c1 = 1;
    for (Point p : p1) {
        path[p] = c1++;
    }

    int c2 = 1;
    int min = 99999;
    for (Point p : p2) {
        if (path[p]) {
            int sum = path[p] + c2;
            if (sum < min) min = sum;
        }
        c2++;
        if (c2 >= min) //This saves about half of the time
            break;
    }

    std::cout << "Snd: " << min << std::endl;
}

int main(){
    const auto p1 = parse(0);
    const auto p2 = parse(1);

    auto start = std::chrono::high_resolution_clock::now();
    fstStar(p1, p2);
    auto endfst = std::chrono::high_resolution_clock::now();
    sndStar(p1, p2);
    auto endsnd = std::chrono::high_resolution_clock::now();


    std::chrono::duration<double> elapsedFst = endfst - start;
    std::chrono::duration<double> elapsedSnd = endsnd - endfst;

    std::cout << "Fst took: " << elapsedFst.count() << "; Snd took: " << elapsedSnd.count() << std::endl;
}