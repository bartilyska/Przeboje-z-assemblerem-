#include<stdio.h>
#include<stdlib.h>
extern void roznica(long long odjemna[], long long odjemnik[], long long * wsk, unsigned int n);//wskazniki leca a mam wypluc wskaznik wynikowej
int main()
{
	unsigned int n = 5;
	long long  odjemna[] = { 10, 20, 30, 40, 50 };
	long long  odjemnik[] = { 1, 2, 3, 4, 5 };
	long long* wsk = (long long *)malloc(n * sizeof(long long));
	roznica(odjemna, odjemnik, wsk, n);
	for (int i = 0; i < n; i++)
	{
		printf("%lld - %lld =%lld\n", odjemna[i], odjemnik[i], wsk[i]);
	}
	free(wsk);
	return 0;
}