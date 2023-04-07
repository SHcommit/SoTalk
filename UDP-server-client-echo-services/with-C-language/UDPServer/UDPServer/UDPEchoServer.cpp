#pragma comment (lib, "ws2_32.lib")

#include <winsock2.h>
#include <stdio.h>

#define PORT 9000
#define MAXBUF 256

int main(void) {
	SOCKADDR_IN servAddr;
	SOCKADDR_IN clientAddr;
	SOCKET servSocket;
	WSADATA wsadata;

	int ret, len, size;
	char buf[MAXBUF];

	if (WSAStartup(MAKEWORD(2, 2), &wsadata)) { return 0; }

	servSocket = socket(AF_INET, SOCK_DGRAM, 0);
	if (servSocket == INVALID_SOCKET) {
		printf("Socket Create : 실패 (%d)\n", WSAGetLastError());
		return 0;
	}

	ZeroMemory(&servAddr, sizeof(servAddr));
	servAddr.sin_family = AF_INET;
	servAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
	servAddr.sin_port = htons(PORT);

	ret = bind(servSocket, (SOCKADDR*)&servAddr, sizeof(servAddr));
	if (ret == SOCKET_ERROR) {
		printf("Socket Bind : 실패(%d)\n", WSAGetLastError());
		closesocket(servSocket);
		return 0;
	}

	size = sizeof(clientAddr);

	for (;;) {
		printf("클라이언트로부터 데이터를 기다린다.\n");
		ret = recvfrom(
			servSocket,
			buf,
			sizeof(buf),
			0,
			(SOCKADDR*)&clientAddr, &size);

		if (ret == SOCKET_ERROR) {
			printf("recvfrom : 실패(%d)\n", WSAGetLastError());  break; 
		}

		buf[ret] = 0;
		printf("read ===> %s\n", buf);
		ret = sendto(
			servSocket,
			buf,
			ret,
			0,
			(SOCKADDR*)&clientAddr,
			size);

		if (ret == SOCKET_ERROR) {
			printf("sento : 실패(%d)", WSAGetLastError()); break;
		}

	}

	closesocket(servSocket);
	WSACleanup();

	return 0;
}