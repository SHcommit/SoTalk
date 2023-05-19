#include <stdio.h>
#include <Windows.h>

int main(void) {
	HANDLE hMutex;
	char inputChar[10];

	hMutex = CreateMutex(NULL, FALSE, "ShareMutex");
	WaitForSingleObject(hMutex, INFINITE);

	printf("Gain Mutex\n");
	scanf("%s", inputChar);
	ReleaseMutex(hMutex);
	printf("ReleaseMutex\n");
	scanf("%s", inputChar);
	WaitForSingleObject(hMutex, INFINITE);
	printf("Gain Mutex\n");
	scanf("%s", inputChar);
	ReleaseMutex(hMutex);
	printf("Release Mutes\n");
	return 1;
}