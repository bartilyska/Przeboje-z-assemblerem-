#include<stdio.h>
#include<stdlib.h>
extern void roznica(int odjemna[], int odjemnik[], int*wsk ,unsigned int n);//wskazniki leca a mam wypluc wskaznik wynikowej
int main()
{
	unsigned int n = 5; 
	int odjemna[] = { 10, 20, 30, 40, 50 }; 
	int odjemnik[] = { 1, 2, 3, 4, 5 };
	int* wsk = (int*)malloc(n * sizeof(int));
	roznica(odjemna, odjemnik,wsk, n);
	for (int i = 0; i < n; i++) 
	{
		printf("%d - %d =%d\n", odjemna[i], odjemnik[i],wsk[i]);
	}
	free(wsk);
	return 0;
}