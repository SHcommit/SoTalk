#pragma comment (lib, "ws2_32.lib")

#include <winsock2.h>
#include <stdio.h>
#include <stdlib.h>

const u_short PORT = 9000;
const u_short BUFSIZE = 512;

int main(void) {
	printf("BroadCast Receiver start:)\n");
	WSADATA wsa;
	SOCKADDR_IN localAddr;
	int retval;

	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) { return 0; }

	SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);

	ZeroMemory(&localAddr, sizeof(localAddr));
	localAddr.sin_family = AF_INET;
	localAddr.sin_port = htons(PORT);
	localAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);

	retval = bind(sock, (SOCKADDR*)&localAddr, sizeof(localAddr));
	if (retval == SOCKET_ERROR) {
		printf("Socket bind : Fail(%d)", WSAGetLastError());
		return 0;
	}

	SOCKADDR_IN peerAddr;
	int addrLen;
	char buf[BUFSIZE + 1];

	while (true) {
		addrLen = sizeof(peerAddr);
		retval = recvfrom(
			sock,
			buf,
			BUFSIZE,
			0,
			(SOCKADDR*)&peerAddr,
			&addrLen);
		if (retval == SOCKET_ERROR) {
			printf("Receive data : Fail(%d)", WSAGetLastError());
			continue;
		}

		buf[retval] = '\0';
		printf("[UPD/%s:%d] %s\n", inet_ntoa(peerAddr.sin_addr), htons(peerAddr.sin_port), buf);
	}

	closesocket(sock);
	WSACleanup();
	return 0;
}