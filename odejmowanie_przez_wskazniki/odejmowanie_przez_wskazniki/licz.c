#include<stdio.h>
int odejmowanie(int** odjemna, int* odjemnik);
int sum(unsigned int n,...);
int reduction(int tab[], unsigned int n, int type);
int* merge(int tab1[], int tab2[], int n);
#define SIZE 8
int main()
{
	int a, b, * wsk, wynik;
	wsk = &a;
	a = -21, b = -25;
	/*wynik = odejmowanie(&wsk, &b);
	printf("%d \n", wynik);
	int suma = sum(4,6,6,6,6);
	printf("%d\n", suma);
	int tab[5] = { -12,-9,9,11,0 };
	int red1 = reduction(tab, 5, -1);
	printf("%d\n", red1);
	int red2 = reduction(tab, 5, 0);
	printf("%d\n", red2);
	int red3 = reduction(tab, 5, 1);
	printf("%d\n", red3);*/
	int tab1[8] = { 2,4,6,8,10,12,14,16 };
	int tab2[8] = { 1,3,5,7,9,11,13,15 };
	int* tab3 = merge(tab2, tab1, SIZE);
	if (tab3 == 0) {
		printf("Blad!\\n");
		return -1;
	}
	for (int i = 0; i < SIZE * 2; i++) {
		printf_s("%d ", tab3[i]);
	}
	return 0;
}