#include <stdio.h>
float add2floats(float a, float b);
int main() {
    float a = 3.996;
    float b = 8.001;
    float c = add2floats(a, b);
    printf("c = %f\n", c);
    return 0;
}