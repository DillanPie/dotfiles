#include <iostream>

int getPositiveNumber(int &x) {
    int input;

    std::cin >> input;
    x = input;
   
    return x;
}

// Function to compute power using recursion
int calculatePower(int base, int exponent) {
    // Base case: anything raised to the power of 0 is 1
    if (exponent == 0) {
        return 1;
    }

    // If exponent is even
    if (exponent % 2 == 0) {
        // Recursive call with half the exponent
        double temp = calculatePower(base, exponent / 2);
        return temp * temp;
    } else {
        // Recursive call with half the exponent minus one
        double temp1 = calculatePower(base, (exponent - 1) / 2);
        double temp2 = temp1 * temp1;

        return base * temp2;
    }
}

int main() {
    int base;
    int exponent;

    // Get base and exponent from user
    getPositiveNumber(base);
    getPositiveNumber(exponent);

    // Calculate power using recursion
    double result = calculatePower(base, exponent);

    // Print the result
    std::cout << "Result: " << result << std::endl;

    return 0;
}