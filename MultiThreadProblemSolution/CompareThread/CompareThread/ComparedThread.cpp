#include <stdio.h>
#include <Windows.h>

char exThread[100];

DWORD WINAPI Thread1(LPVOID arg) {
	for (int i = 0; i < 100; i++) {
		exThread[i] = 'A';
		Sleep(10);
	}
	return 0;
}

DWORD WINAPI Thread2(LPVOID arg) {
	for (int i = 99; i >= 0; i--) {
		exThread[i] = 'B';
		Sleep(10);
	}
	return 0;
}

int main(void) {
	HANDLE hThread[2];
	DWORD ThreadId[2];

	hThread[0] = CreateThread(NULL, 0, Thread1, NULL, 0, &ThreadId[0]);
	hThread[1] = CreateThread(NULL, 0, Thread2, NULL, 0, &ThreadId[1]);
	
	WaitForMultipleObjects(2, hThread, TRUE , INFINITE);
	for (int i = 0; i<100;i++) {
		printf("%c", exThread[i]);
	}
	printf("\n");
	return 0;
}