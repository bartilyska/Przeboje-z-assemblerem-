#include <stdio.h>
char* komunikat(char* tekst);
void szyfruj(char* tekst);
unsigned int kwadrat(unsigned int a);
unsigned char iteracja(unsigned char a);
int main() 
{
	char* tekst1 = "PIEKNIE!!!";
	int dlugosc = 11;
	char* tekst2 = komunikat(tekst1);
	for (int i = 0; i < (dlugosc + 5); i++) {
		printf("%c", *(tekst2 + i));
	}

	char tekst[] = "tajne";
	szyfruj(tekst);

	unsigned int a = 65000;
	unsigned int wynik = kwadrat(a);
	printf("Kwadrat liczby %u to %u", a, wynik);

	char w = iteracja(32);
	printf("Znak : %c", w);
	printf("\n");
	return 0;
}