#include <stdio.h>
float srednia_harm(float* tablica, unsigned int n);
int main()
{
	unsigned int n = 5;
	float tablica[5] = { 1.0, 2.0, 3.0, 4.0, 5.0 };
	float wynik = srednia_harm(tablica, n);
	printf("Srednia harmoniczna wynosi: %f\n", wynik);
	return 0;
}