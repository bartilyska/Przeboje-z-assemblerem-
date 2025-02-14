#include <stdio.h>
#include<Windows.h>
#include <compressapi.h>
wchar_t* kompresuj(unsigned int id_kompresora, wchar_t* dane);
int main()
{
	wchar_t dane[] =L"Alamakota";
	wchar_t* skompresowane = kompresuj(4, dane);
	wprintf("%s\n", skompresowane);

	return 0;
}