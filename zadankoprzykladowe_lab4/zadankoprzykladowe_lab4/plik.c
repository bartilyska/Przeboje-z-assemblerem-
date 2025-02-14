#include<stdio.h>
int* szukaj_max(int pomiary[], int n);
int main()
{
	int pomiary[7]={-543,-65,-7,-543,-12,-65,-6}, * wsk;
	wsk = szukaj_max(pomiary, 7);
	printf("maxi %d", *wsk);
	return 0;
}