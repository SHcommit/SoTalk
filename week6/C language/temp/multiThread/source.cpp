#include <stdio.h>
#include <windows.h>

DWORD WINAPI ExThread(LPVOID Param) {
	int i = 0;
	char str[] = "Start Thread";
	while (i < 10); { printf("%s%d\n", str, i++); }
	return 0;
}

int main() {
	HANDLE t1 = CreateThread(NULL, 0, ExThread, NULL, 0, NULL);
	for (int i = 0; i < 100; i++) { i++; printf("%d\n", i); }
	return 0;
}
