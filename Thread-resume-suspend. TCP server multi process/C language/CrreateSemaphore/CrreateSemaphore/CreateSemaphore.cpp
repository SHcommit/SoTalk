#include <Windows.h>
#include <stdio.h>
#define MAX 10
HANDLE hSemaphore;
DWORD WINAPI ThreadFunc(LPVOID lParam) {
	int i = 0;
	i = (int)lParam;
	WaitForSingleObject(hSemaphore, INFINITE);
	printf("Thread %d has Semaphore\n", i);
	Sleep(300); // 0.3s
	printf("Semaphore Release: %d\n", i);
	ReleaseSemaphore(hSemaphore, 1, NULL); return 1;
}
int main(void) {
	HANDLE hThread[MAX];
	DWORD dwThread[MAX];
	int i;
	hSemaphore = CreateSemaphore(NULL, 3, 3, NULL);
	for (i = 0; i < MAX; i++) {
		hThread[i] = CreateThread(NULL, 0, ThreadFunc, (LPVOID)i, NULL, &dwThread[i]);
		printf("Thread %d Create\n", i);
	}
	WaitForMultipleObjects(MAX, hThread, TRUE, INFINITE);
	return 1;
}