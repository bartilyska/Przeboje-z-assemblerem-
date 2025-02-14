#include <stdio.h>
unsigned char czy_pierwsza(unsigned int a);
unsigned char pierwsza(unsigned int a) {
	if (a < 2) return 0;
	if (a == 2) return 1;
	if (a % 2 == 0) return 0;
	for (unsigned int i = 3; i * i <= a; i += 2) {
		if (a % i == 0) return 0;
	}
	return 1;
}
void wypisz_pierwsze(int n) {
	for (unsigned int i = 2; i <= n; i++) {
		if (pierwsza(i)) {
			printf("%u ", i);
		}
	}
}
unsigned int ilosc_liczb_pierwszych(int n, int* tablica, int* dostepy);
float liczba_pi(unsigned int n);
void wypisz(unsigned int a);
float dzielenie(unsigned int a, unsigned int b); // a / b
int okresl_blad(float d, int x, int y, float epsilon);
void rysuj_hiperbole(float d,int * tab, int x, int y, float epsilon);
typedef struct 
{
	char a;
	int b;
} struktura;
void* wystapienia(void* tab, int n);
int walec(float x, float y, float z);
void sekwencja(char znak);
void minus_dwojkowy(int x);
float razy_dziesiec(float x);
int oblicz_mex(int* tab, int n);
int main() {
	unsigned int a = 100;
	//printf("%u\n",pierwsza(a));
	//printf("\n");
	//wypisz_pierwsze(a);
	//printf("\n");
	//printf("%u\n",czy_pierwsza(a));
	//wypisz_pierwsze_asm(a);
	//int n = 10;
	//int tablica[10] = { 9,10,11,12,13,14,15,16,17,19 };
	//int dostepy[10] = { 1,1,1,0,0,0,1,1,1,1 };
	//ilosc_liczb_pierwszych(n, tablica, dostepy);
	//printf("%f", liczba_pi(10000));
	//printf("%f", dzielenie(2, 3));
	//char c[11] = "abab445566?";
	//wystapienia(c, 11);
	//printf("%d",walec(3.01, 4, 9));
	/*char c[11] = "00110110110";
	for (int i = 0; i < 11; i++)
	{
		sekwencja(c[i]);
	}*/
	/*int b = okresl_blad(2.5, 0, 100, 5.1);
	int tab[10][10] = { 0 };
	rysuj_hiperbole(2.5, tab, 10, 10, 5.1);
	/*for (int i = 0; i < 100; i++)
	{
		for (int j = 0; j < 100; j++)
		{
			printf("%d", tab[i][j]);
		}
		printf("\n");
	}*/
	/*int x = -125;
	minus_osemkowy(x);*/
	/*float x = 4;
	float odp = razy_dziesiec(x);
	printf("%f", odp);*/
	int n = 10;
	int tab[10] = { 9,8,7,6,5,4,3,2,0,9 };
	int x = oblicz_mex(tab, n);
	printf("%d", x);
	return 0;
}