#include <stdio.h>
float obj_stozka(float r, float R, float h) {
	return 3.14 * h * (r * r + r * R + R * R) / 3.0;
}
float moja(float r, float R, float h);
int main() {
	float r=134.5, R=156.7, h=39.9;
	float obj = obj_stozka(r, R, h);
	float moj = moja(r, R, h);
	printf("obj = %f\n", obj);
	printf("moja = %f\n", moj);
	return 0;
}