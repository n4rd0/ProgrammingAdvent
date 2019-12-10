#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>
#include <sstream>
#include <map>
#include <algorithm>


struct Point
{
    int x;
    int y;
};

const int gcd(int a, int b) {
    int d = b % a;
    if (d == 0) return a;
    return gcd(d, a);
}

const double atan(const Point p) {
    if (p.x == 0)
        return p.y < 0? -99999. : 99999.;
    return (double) p.y / (double) p.x;
}

Point operator+(const Point &self, const Point &other){
    //I know it shouldn't be like this but it is how it works with the directions
    return (Point) {.x = self.x + other.x, .y = self.y - other.y};
}

const bool operator==(const Point& self, const Point& other) {
    return self.x == other.x && self.y == other.y;
}

const bool operator<(const Point& self, const Point& other) {
    return self.x < other.x || (self.x == other.x && self.y < other.y);
}

const bool clockwise(const Point& other, const Point& self) {
    if (self.x * other.x < 0){
        return self.x < other.x;
    }

    return atan(self) < atan(other);
}

std::vector<Point> parse() {
    std::string line;
    std::ifstream last("data.txt");
    std::vector<Point> vals;
    vals.clear();
    Point p;
    if (last.is_open()){

        int i = 0, j = 0;
        while(getline(last, line)){
            std::stringstream ss(line);
            std::string item;
            for (j = 0; j < line.length(); ++j)
            {
                if (line[j] == '#') {
                    vals.push_back((Point) {.x = j, .y = i});
                }
            }

            i++;
        }
        last.close();

        //Add the dimensions at the end, useful for the sndStar
        vals.push_back((Point) {.x=j, .y=i});
    }
    else
        std::runtime_error("Can't open data.txt, ensure it is in the cwd");

    return vals;
}


Point normalize(int x, int y) {
    if (x == 0) return (Point){.x=0, .y = y == 0? 0 : y < 0? -1 : 1};
    int g = gcd(std::abs(x), std::abs(y));

    return (Point) {.x = x / g, .y = y / g};
}

int bestPos(std::vector<Point> v, Point &best) {

    int max;

    std::map<Point, bool> m_pt;

    //For each asteroid
    for (const Point &place : v)
    {
        m_pt.clear();
        //Count how many asteroids are visible
        for (const Point &p : v)
        {
            int vx = p.x - place.x, vy = p.y - place.y;
            Point dir = normalize(vx, vy);
            if (!m_pt[dir]) m_pt[dir] = true;
        }

        if (m_pt.size() > max){
            max = m_pt.size();
            best.x = place.x;
            best.y = place.y;
        }
    }

    return max - 1;
}

Point destroy(std::vector<Point> v, int num) {

    int xdim = v.back().x, ydim = v.back().y;
    v.pop_back();

    std::vector<Point> dirs;
    std::map<Point, bool> m_pt, m_ds; //m_pt is for the points, m_ds for the directions

    Point from;
    bestPos(v, from);

    //Populate maps and dirs with the respective points and directions
    for (const Point &p : v)
    {
        m_pt[p] = true;
        if (!(p == from)) {
            int vx = p.x - from.x, vy = from.y - p.y; //This is because (0,1) == down
            Point n = normalize(vx, vy);
            if (!m_ds[n]) {
                dirs.push_back(n);
                m_ds[n] = true;
            }
        }
    }

    //We sort the directions so that they are in clockwise order
    std::sort(dirs.begin(), dirs.end(), clockwise);

    Point lastDestroyed;
    int i = 0, j = -1;
    //Vaporize num + 1 asteroids
    while (i < num)
    {
        //Iterate through all the directions
        bool nextAsterFound = false;
        while (!nextAsterFound){
            j = (j+1) % dirs.size();
            //We already know that there aren't more asteroids in this dir
            if (!m_ds[dirs[j]]) continue;

            Point d = from + dirs[j];

            //Detect if there is a point in the direction
            while (d.x >= 0 && d.y >= 0 && d.x < xdim && d.y < ydim)
            {
                if (m_pt[d]) {
                    lastDestroyed = d;
                    m_pt.erase(d);
                    nextAsterFound = true;
                    break;
                }
                d = d + dirs[j];
            }
            m_ds[dirs[j]] = nextAsterFound;
        }

        i++;
    }

    return lastDestroyed;
}

void fstStar(std::vector<Point> v){

    v.pop_back(); //We don't need the dimensions
    Point _p;
    int res = bestPos(v, _p);
    std::cout << "Fst: " << res << std::endl;
}

void snm_dstar(const std::vector<Point> &v){

    Point p = destroy(v, 199);
    std::cout << "Snd: " << p.x << ", " << p.y << std::endl;
}

int main(){
    const auto v = parse();

    auto start = std::chrono::high_resolution_clock::now();
    fstStar(v);
    auto endfst = std::chrono::high_resolution_clock::now();
    snm_dstar(v);
    auto endsnd = std::chrono::high_resolution_clock::now();


    std::chrono::duration<double> elapsedFst = endfst - start;
    std::chrono::duration<double> elapsem_dsnd = endsnd - endfst;

    std::cout << "Fst took: " << elapsedFst.count() << "; Snd took: " << elapsem_dsnd.count() << std::endl;
}