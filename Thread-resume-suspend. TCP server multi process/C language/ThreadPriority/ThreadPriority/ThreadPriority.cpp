#include <stdio.h>
#include <windows.h>

DWORD WINAPI ExThread(LPVOID lpParam) {
	while (true) { printf("Running ExThread!\n"); } return 0;
}

int main(void) {
	HANDLE thread = CreateThread(NULL, 0, ExThread, NULL, 0, NULL);
	SetThreadPriority(thread, THREAD_PRIORITY_HIGHEST);
	while (true) { printf("Running main thread\n"); } return 0;
}