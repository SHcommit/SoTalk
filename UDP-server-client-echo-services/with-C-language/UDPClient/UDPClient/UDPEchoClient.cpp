#pragma comment (lib, "ws2_32.lib")

#include <winsock2.h>
#include <stdio.h>

#define PORT 9000
#define MAXBUF 4096

int main() {

	//MARK: - Properties
	SOCKET clientSocket;
	SOCKADDR_IN servAddr, recvAddr;
	char buf[MAXBUF + 1];
	int ret, size;
	WSADATA wsadata;

	if (WSAStartup(MAKEWORD(2, 2), &wsadata)) { return 0; }

	clientSocket = socket(AF_INET, SOCK_DGRAM, 0);
	if (clientSocket == INVALID_SOCKET) {
		printf("Socket create : 실패 (%d)\n", WSAGetLastError()); return 0;
	}

	ZeroMemory(&servAddr, sizeof(servAddr));
	servAddr.sin_family = AF_INET;
	servAddr.sin_port = htons(PORT);
	servAddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");

	while (true) {
		printf("전달할 데이터 : ");
		scanf("%s", buf);
		ret = sendto(
			clientSocket,
			buf,
			strlen(buf),
			0,
			(struct sockaddr*)&servAddr,
			sizeof(servAddr));

		if (ret == SOCKET_ERROR) {
			printf("sendto error :%d\n", WSAGetLastError());
			closesocket(clientSocket); return 0;
		}

		printf("sendto ===> %s\n", buf);

		size = sizeof(recvAddr);
		ret = recvfrom(
			clientSocket,
			buf,
			sizeof(buf),
			0,
			(struct sockaddr*)&recvAddr, &size);

		if (ret == SOCKET_ERROR) {
			printf("sendto error : %d\n", WSAGetLastError());
			closesocket(clientSocket); return 0;
		}
		buf[ret] = 0;
		printf("recvfrom ===> %s\n", buf);
	}
	closesocket(clientSocket);
	WSACleanup(); 
	return 0;
}