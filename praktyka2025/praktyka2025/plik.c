#include <stdio.h>
#include <xmmintrin.h>
long long salt(wchar_t* nazwa, float x);
__m128 mul64(long long a, long long b);
//__m128 mulinny(long long a, long long b);
typedef struct int48
{
	long long x0;
}uint48;
void gen_xi(struct int48* x, int C);
int main()
{
	uint48 xi;
	//long long int l = salt(L"Winiary", 21.37f);
	xi.x0 = salt(L"Winiary", 21.37f);
	xi.x0 = 0x666554443332;
	__m128 m = mul64(66546757567565, 86575675675675677);
	//__m128 d = mulinny(66546757567565, 86575675675675677);
	printf("%lld", m);
	gen_xi(&xi, 3);
	return 0;
}