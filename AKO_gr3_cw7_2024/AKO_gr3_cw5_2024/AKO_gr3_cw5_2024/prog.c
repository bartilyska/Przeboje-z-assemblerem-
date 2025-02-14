#include <stdio.h>
#include <xmmintrin.h>


//extern int wyswietl_EAX(long long, long long);
//extern void jaka(Dane);
struct dane
{
	char a;
	short b;
	int c;

};

typedef struct dane Dane;

void main()
{
	__m128 a;
	a.m128_u64[0] = 0xFFFFFFFFFFFFFFFE;
	a.m128_u64[1] = 0xFFFFFFFFFFFFFFFF;

	Dane test;
	test.a = 'A';
	test.b = 3;
	test.c=  4;
	//jaka(test);
	wyswietl_EAX(0xFFFFFFFFFFFFFFFE, 0xFFFFFFFF);
}