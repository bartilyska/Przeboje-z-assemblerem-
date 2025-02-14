#include <stdio.h>
#include <stdint.h>
#include <math.h>

typedef uint16_t binary16;

float binary16_to_float(binary16 h) {
    uint32_t sign = (h & 0x8000) << 16;
    uint32_t exponent = (h & 0x7C00) >> 10;
    uint32_t mantissa = h & 0x03FF;

    if (exponent == 0) {
        if (mantissa == 0) {
            return sign ? -0.0f : 0.0f;
        }
        else {
            while ((mantissa & 0x0400) == 0) {
                mantissa <<= 1;
                exponent--;
            }
            exponent++;
            mantissa &= ~0x0400;
        }
    }
    else if (exponent == 0x1F) {
        if (mantissa == 0) {
            return sign ? -INFINITY : INFINITY;
        }
        else {
            return NAN;
        }
    }

    exponent = exponent + (127 - 15);
    uint32_t result = sign | (exponent << 23) | (mantissa << 13);
    return *(float*)&result;
}
float konwertuj(binary16 a);
int main() {
    binary16 a = 0xC000;
    float a_float = binary16_to_float(a);
    float b_float = konwertuj(a);
    printf("Value of a: %f b : %f\n", a_float,b_float);
    return 0;
}