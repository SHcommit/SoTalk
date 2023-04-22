#include <stdio.h>
#include <windows.h>

DWORD WINAPI ExThread(LPVOID Param) {
	char str[] = "Start Thread";
	for (int i = 0; i < (int)Param; i++) { printf("%s%d\n", str, i); }
	return 0;
}

DWORD WINAPI ExThread2(LPVOID Param) {
	char str[] = "Start Thread number two";
	for (int i = 0; i < (int)Param; i++) { printf("%s%d\n", str, i); }
	return 0;
}

int main() {
	int param = 300;
	HANDLE t1 = CreateThread(NULL,0,ExThread,(LPVOID)param,0,NULL);
	HANDLE t2 = CreateThread(NULL,0,ExThread2,(LPVOID)param,
		0,
		NULL);

	for (int i = 0; i < 500000; i++) { i++;  if (i % 2500 == 1) printf("MainThread %d\n", i); }
	return 0;
}
