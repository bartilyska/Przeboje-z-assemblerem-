#include <stdio.h>
void przestaw(int* tablica, int n);
int main()
{
	int n = 5;
	int tablica[5] = { 0,5,-2,-7,1 };
	for (int i = 0; i < 5; i++)
	{
		przestaw(tablica, n);
		n--;
	}
	for (int i = 0; i < 5; i++)
	{
		printf(" %d ", tablica[i]);
	}
	return 0;
}