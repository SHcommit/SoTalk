#include <stdio.h>
#include <windows.h>

DWORD WINAPI PrintA(LPVOID lpParam) {
	while (true) { printf("A"); Sleep(100); } return 0;
}

DWORD WINAPI PrintB(LPVOID lpParam) {
	while (true) { printf("B"); Sleep(100); } return 0;
}

int main(void) {
	HANDLE t1 = CreateThread(NULL, NULL, PrintA, 0, 0, NULL);
	HANDLE t2 = CreateThread(NULL, NULL, PrintB, 0, 0, NULL);

	WaitForSingleObject(t1, INFINITE);
	WaitForSingleObject(t2, INFINITE);
	return 0;
}