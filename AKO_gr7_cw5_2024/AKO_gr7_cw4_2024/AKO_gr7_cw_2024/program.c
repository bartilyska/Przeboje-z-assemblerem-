#include <stdio.h>
#include <xmmintrin.h>

extern void wyswietl_128(__m128);
extern void funkcja(Dane);

struct dane
{
	char a;
	short b;
	int c;
};

typedef struct dane Dane;

void main()
{
	Dane test;
	test.a = 'a';  // db 'a',0cch
	test.b = 2;    // dw 2
	test.c = 3;    // dd 3

	//funkcja(test);
	// long long a;
	//
	__m128 a;
	a.m128_u64[0] = 0xfffffffffffffffe;
	a.m128_u64[1] = 0xffffffffffffffff;
	wyswietl_128(a);
}