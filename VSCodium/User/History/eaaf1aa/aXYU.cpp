#include <iostream>

//function definition
int returnPower(int x, int y){
    int base = x;
    int exponent = y;
    int num = 0;

    if (exponent <= 1) {
        return base;
    }

    if (y%2 == 0) {
        num += returnPower(base, exponent/2) * returnPower(base, exponent/2);
    }
    if (y%2 == 1) {
        num += returnPower(base, (exponent-1)/2) * returnPower(base, (exponent-1)/2) * base;
    }
    return num;
}

int main() {

    int test = returnPower(2,5);
    std::cout << test << std::endl;
    return 0;
}