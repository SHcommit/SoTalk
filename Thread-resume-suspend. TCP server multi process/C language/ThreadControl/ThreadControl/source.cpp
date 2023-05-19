#include <stdio.h>
#include <windows.h>

DWORD WINAPI ExThread(LPVOID lparam) {
	while (true) { printf("Running Thread!\n"); }
	return 0;
}

int main(void) {
	char inputch[512];
	HANDLE hThread;
	hThread = CreateThread(NULL, 0, ExThread, 0, 0, NULL);
	while (true) {
		scanf_s("%s", inputch);
		if (!strcmp(inputch, "suspend")) {
			SuspendThread(hThread);
		} else if (!strcmp(inputch, "resume")) {
			ResumeThread(hThread);
		} else {
			break;
		}
	}
	return 0;
}