#include <stdio.h>
#include <Windows.h>

int main(void) {
	HANDLE hMutex;
	char inputChar[10];

	hMutex = OpenMutex(SYNCHRONIZE, FALSE, "ShareMutex");

	WaitForSingleObject(hMutex, INFINITE);
	printf("Gain Mutex\n");
	scanf("%s", inputChar);

	ReleaseMutex(hMutex);
	printf("Release Mutex\n");
	return 1;
}