#include<stdio.h>
unsigned int readmsg(char* filename);
int main()
{
	char tab[12] = "pliczek.txt";
	unsigned int wynik = readmsg(tab);
	printf("%d", wynik);
	return 0;
}