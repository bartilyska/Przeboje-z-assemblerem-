#include <stdio.h>
void plus_jeden(int** a);
int main()
{
	int m;
	int* wsk;
	wsk = &m;
	m = -905;
	plus_jeden(&wsk);
	printf("\n m = %d\n", m);
	return 0;
}
