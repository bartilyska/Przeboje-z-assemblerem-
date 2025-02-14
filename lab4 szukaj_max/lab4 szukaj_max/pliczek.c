#include <stdio.h>
int szukaj_max(int a, int b, int c, int d);
int main()
{
	int u,x, y, z, wynik;
	printf("Podaj trzy liczby ze znakiem: ");
	scanf_s("%d %d %d %d", &u, &x, &y, &z);
	wynik = szukaj_max(u, x, y, z);
	printf("Sposrod podanych liczb %d,  %d, %d, %d,liczba %d jest najwieksza\n", u , x, y, z, wynik);
	return 0;
}