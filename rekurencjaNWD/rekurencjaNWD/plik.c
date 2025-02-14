#include <stdio.h>
int moja(int a, int b);
int gcd(int a, int b) {
	if (b == 0) return a;
	return gcd(b, a % b);
}
int main() {
	int a = 120, b = 270;
	int g = gcd(a, b);
	int l = moja(a, b);
	printf("NWD(%d, %d) = %d\n", a, b, g);
	printf("NWD(%d, %d) = %d\n", a, b, l);
	return 0;
}