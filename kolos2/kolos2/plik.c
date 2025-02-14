#include <stdio.h>

extern  void _stdcall reverse_string(wchar_t *);

void main()
{
	wchar_t input[] = L"2 muiwkolok OKA";
	reverse_string(input);
	printf("%ls\n", input);
}