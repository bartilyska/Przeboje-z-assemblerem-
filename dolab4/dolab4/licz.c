#include <stdio.h>
void przestaw(int* tablica, int n);
unsigned int abs_med(int* tablica, int n);
#define rozm 9
int main()
{
	int d = rozm;
	int n = rozm;
	int tablica[rozm] = { 0,5,-2,-9,1,-99,15,1000,1000 };
	for (int i = 0; i < 5; i++)
	{
		przestaw(tablica, n);
		n--;
	}
	printf("Tablica po abs i sorcie: \n");
	for (int i = 0; i < rozm; i++)
	{
		printf(" %i ", tablica[i]);
	}
	printf("\n");
	unsigned int wynik = abs_med(tablica, d);
	printf("Mediana po abs: %d ", wynik);
	return 0;
}