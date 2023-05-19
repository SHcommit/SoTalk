#include <Windows.h>
#include <stdio.h>
#define MAX 5
HANDLE hEvent;
DWORD WINAPI ThreadFunc(LPVOID lParam) {
	int i = (int)lParam;
	printf("Thread %d Created\n", i);
	WaitForSingleObject(hEvent, INFINITE);
	printf("Thread %d has Event\n", i);
	Sleep(2000);
	return 1;
}
int main() {
	HANDLE hThread[MAX];
	DWORD dwThreadId[MAX];
	int i;
	hEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
	for (i = 0; i < MAX; i++) {
		hThread[i] = CreateThread(NULL, 0, ThreadFunc, (LPVOID)i, NULL, &dwThreadId[i]);
	}
	SetEvent(hEvent);
	WaitForMultipleObjects(MAX, hThread, TRUE, INFINITE);
	return 1;
}