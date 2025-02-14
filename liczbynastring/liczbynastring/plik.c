#include<stdio.h>
char* tekst(long long int x, long long int y);
char* start;
int main()
{
	start = (char*)malloc(sizeof(char) * 129);
	long long int x=0xFFFFEEEEDDDDCCCC, y = 0xAAAABBBBCCCC7777;
	start = tekst(x, y);
	free(start);
	return 0;
}