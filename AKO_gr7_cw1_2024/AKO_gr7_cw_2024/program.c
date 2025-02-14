#include <stdio.h>
#include <Windows.h>



int a;

void main()
{
	a = MessageBox(NULL, L"Czy lubisz AKO?", L"Pytanie", MB_YESNO);
}