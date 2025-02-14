#include <stdio.h>
double wariancja(double* tablica_dane,unsigned int n);
int main()
{
	unsigned int n = 5;
	double tablica_dane[5] = { 2.5,4.9,6.8,7.1,9.5 };
	double wynik = wariancja(tablica_dane, n);
	printf(" Wariancja wynosi : %lf", wynik);
	return 0;
}