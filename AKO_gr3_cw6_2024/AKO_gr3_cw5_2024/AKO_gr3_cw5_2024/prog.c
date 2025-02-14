#include <stdio.h>

extern int wyswietl_EAX(unsigned int);

void main()
{
	wyswietl_EAX(0xFFFFFFFF);
}