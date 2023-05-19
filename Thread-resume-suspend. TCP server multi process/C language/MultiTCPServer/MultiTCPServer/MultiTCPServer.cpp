#pragma comment (lib, "ws2_32.lib")
#include <winsock2.h>
#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 512
#define PORT 9000

DWORD WINAPI ClientThread(LPVOID arg) {
	SOCKET sockClient = (SOCKET)arg;
	char buf[BUFSIZE + 1];
	SOCKADDR_IN addrClient;
	int addrlen;
	int ret;

	addrlen = sizeof(addrClient);
	getpeername(sockClient, (SOCKADDR*)&addrClient, &addrlen);

	while (true) {
		ret = recv(sockClient, buf, BUFSIZE, 0);
		if (ret == SOCKET_ERROR) {
			printf("recv() Error\n"); break;
		}
		else if (ret == 0) { break; }

		buf[ret] = '\0';
		printf("[TCP/%s:%d\t%s\n", inet_ntoa(addrClient.sin_addr), ntohs(addrClient.sin_port), buf);
		ret = send(sockClient, buf, ret, 0);
		if (ret == SOCKET_ERROR) { 
			printf("send() Error\n");
			break; 
		}
	}
	closesocket(sockClient);
	printf("[TCP 서버] 클라이언트 종료 : IP 주소 = %s, 포트 번호 = %d\n",
		inet_ntoa(addrClient.sin_addr),
		ntohs(addrClient.sin_port)
	);
	return 0;
}

int main(void) {
	int recval;
	SOCKET listenSock;
	WSADATA wsa;

	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) printf("WSAStartup error\n");
	listenSock = socket(AF_INET, SOCK_STREAM, 0);
	if (listenSock == INVALID_SOCKET) printf("socket() error\n");
	SOCKADDR_IN servAddr;
	ZeroMemory(&servAddr, sizeof(servAddr));
	servAddr.sin_family = AF_INET;
	servAddr.sin_port = htons(PORT);
	servAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);

	recval = bind(listenSock, (SOCKADDR*)&servAddr, sizeof(servAddr));
	if (recval == SOCKET_ERROR) printf("listen() error\n");

	recval = listen(listenSock, SOMAXCONN);
	if (recval == SOCKET_ERROR) printf("listen() error");

	SOCKET clientSock;
	SOCKADDR_IN addrClient;
	int length;

	HANDLE hThread;
	while (true)
	{
		length = sizeof(addrClient);
		clientSock = accept(listenSock, (SOCKADDR*)&addrClient, &length);
		if (clientSock == INVALID_SOCKET) {
			printf("accept() error\n");
			continue;
		}
		printf("[TCP 서버] 클라이언트 접속 :IP 주소 = %s, 포트번호 = %d\n",
			inet_ntoa(addrClient.sin_addr),
			ntohs(addrClient.sin_port)
		);
		hThread = CreateThread(NULL, 0, ClientThread, (LPVOID)clientSock, 0, NULL);
		if (hThread == NULL) 
			printf("CreateThread() error\n");
		else 
			CloseHandle(hThread);
	}
	closesocket(listenSock);
	WSACleanup();
	return 0;
}