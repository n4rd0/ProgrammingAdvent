#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
#include <chrono>

const int lb = 264360;
const int ub = 746325;

const inline int update(int num, int last){
    return 10 * num + last;
}

//I use a template because it alters how the function works
template <bool once>
const bool isValid(int b[5]){

    for (int i = 0; i < 5; ++i)
    {
        if (b[i]) {
            if (once) {
                if (!((i > 0 && b[i-1] == b[i]) || (i < 4 && b[i+1] == b[i])))
                    return true;
            } else {
                return true;
            }
        }
    }

    return false;
}


template <bool once>
int count(void) {
    int beg = lb / 100000, end = 1 + ub / 100000;
    int num = 0;
    int cnt = 0;
    int b[5] = {0};
    for (int i = beg; i < end; ++i, num /= 10) {
        num = update(num, i);
        for (int j = i; j < 10; ++j, num /= 10) {
            b[0] = num % 10 == j? j : 0;
            num = update(num, j);
            for (int k = j; k < 10; ++k, num /= 10) {
                b[1] = num % 10 == k? k : 0;
                num = update(num, k);
                for (int l = k; l < 10; ++l, num /= 10) {
                    b[2] = num % 10 == l? l : 0;
                    num = update(num, l);
                    for (int m = l; m < 10; ++m, num /= 10) {
                        b[3] = num % 10 == m? m : 0;
                        num = update(num, m);
                        for (int n = m; n < 10; ++n, num /= 10) {
                            b[4] = num % 10 == n? n : 0;
                            num = update(num, n);

                            if (num > ub) goto end;
                            if (num > lb && isValid<once>(b)) cnt++;
                        }
                    }
                }
            }
        }
    }

    end:
    return cnt;
}
void fstStar(void){

    std::cout << "Fst: " << count<false>() << std::endl;
}

void sndStar(void){

    std::cout << "Snd: " << count<true>() << std::endl;
}

int main(){
    auto start = std::chrono::high_resolution_clock::now();
    fstStar();
    auto endfst = std::chrono::high_resolution_clock::now();
    sndStar();
    auto endsnd = std::chrono::high_resolution_clock::now();


    std::chrono::duration<double> elapsedFst = endfst - start;
    std::chrono::duration<double> elapsedSnd = endsnd - endfst;

    std::cout << "Fst took: " << elapsedFst.count() << "; Snd took: " << elapsedSnd.count() << std::endl;
}