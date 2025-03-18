#include <iostream>
#include <chrono>

// // Naive recursive implementation
// unsigned long long fibonacci(unsigned int n) {
//     // Base cases
//     if (n <= 1) {
//         return n;
//     }
    
//     // Recursive case: F(n) = F(n-1) + F(n-2)
//     return fibonacci(n-1) + fibonacci(n-2);
// }

//loop imp

unsigned long long fibonacci(unsigned int n){
    int result;
    while(n <=1){
       result = fibonacci(n-1) + fibonacci(n-2);
    }

    return result;
}

int main() {
    // Test with various inputs
    for (unsigned int i = 0; i <= 10; i += 5) {
        auto start = std::chrono::high_resolution_clock::now();
        unsigned long long result = fibonacci(i);
        auto end = std::chrono::high_resolution_clock::now();
        
        std::chrono::duration<double, std::milli> duration = end - start;
        
        std::cout << "fibonacci(" << i << ") = " << result 
                  << " (calculated in " << duration.count() << " ms)" << std::endl;
    }
    
    return 0;
}