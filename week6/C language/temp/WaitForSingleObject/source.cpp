#include <stdio.h>
#include <windows.h>

char run[] = "Main thread is still active\n";
char stop[] = "Main thread is stop\n";
char subThread[] = "Start Thread";

DWORD WINAPI ExThread(LPVOID Param) {
    for (int i = 0; i < (int)Param; i++) { printf("Thread %d: %d\n", GetCurrentThreadId(), i);}
    return 0;
}

int main() {
    int taskCount = 4;
    HANDLE threads[5];
    for (int i = 0; i < taskCount; i++) {
        threads[i] = CreateThread(NULL, 0, ExThread, (LPVOID)(30), 0, NULL);
        if (threads[i] == NULL) {
            printf("Failed to create thread\n");
            return 1;
        }
    }
    WaitForMultipleObjects(taskCount, threads, TRUE, INFINITE);
    for (int i = 0; i < taskCount; i++) { CloseHandle(threads[i]); }

    return 0;
}