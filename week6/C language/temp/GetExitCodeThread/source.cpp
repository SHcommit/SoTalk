#include <stdio.h>
#include <windows.h>

char run[] = "Main thread is still active\n";
char stop[] = "Main thread is stop\n";
int param = 300;

DWORD WINAPI ExThread(LPVOID Param) {
	char str[] = "Start Thread";
	for (int i = 0; i < (int)Param; i++) { printf("%s%d\n", str, i); }
	return 0;
}

int main() {
	DWORD exitCode;
	HANDLE t1 = CreateThread(NULL, 0, ExThread, (LPVOID)param, 0, NULL);
	for (int i = 0; i < 10; i++) {
		GetExitCodeThread(t1, &exitCode);
		if (exitCode == STILL_ACTIVE) { printf("%s", run); }
		else { printf("%s", stop); break; }
		printf("MainThread %d\n", i); 
	}
	return 0;
}
