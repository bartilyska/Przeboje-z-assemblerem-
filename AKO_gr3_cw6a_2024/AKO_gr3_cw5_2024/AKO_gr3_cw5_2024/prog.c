#include <stdio.h>

extern int wyswietl_EAX(long long, long long);

void main()
{
	wyswietl_EAX(0xaaaaFFFFFFFFFFFE, 0xFFFFFFFF);
}