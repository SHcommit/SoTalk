#include <Windows.h>
#include <stdio.h>
#define MAX 7
HANDLE hEvent;
DWORD WINAPI ThreadFunc(LPVOID lParam) {
	int i = (int)lParam;
	while (1) {
		if (WaitForSingleObject(hEvent, 100) == WAIT_OBJECT_0) {
			printf("ThreadExit\n");
			return 1;
		}
		printf("Thrad Live: %d\n", i);
	}
	return 1;
}
int main(void) {
	HANDLE hThread[MAX];
	DWORD dwThreadId[MAX];
	int i;
	hEvent = CreateEvent(NULL, TRUE, FALSE, NULL);
	for (i = 0; i < MAX; i++) {
		hThread[i] = CreateThread(NULL, 0, ThreadFunc, (LPVOID)i, NULL, &dwThreadId[i]);

	}
	getchar();
	SetEvent(hEvent);
	WaitForMultipleObjects(MAX, hThread, TRUE, INFINITE);
	return 1;
}