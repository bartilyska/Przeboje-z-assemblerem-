#include <stdio.h>
float licz_srednia(int*ilosc, float*jakosc, int n);
int main()
{
	int n=5;
	int ilosc[5] = { 2,4,6,7,9 };
	float jakosc[5] = { 4,4,4,4,5 };
	float wynik = licz_srednia(ilosc, jakosc, n);
	printf("%f", wynik);
	return 0;
}