#pragma comment (lib, "ws2_32.lib")
#include <WinSock2.h>
#include <stdio.h>
#include <stdlib.h>

//버퍼 사이즈도 2로도 해보고 변형해봐라
#define BUFSIZE 5
// 포트번호도 1023 이하로 해봐
//포트번호도 7만이상으로도해봐
#define PORT 9000

int main() {
	int retval;
	SOCKET listenScoket;
	WSADATA wsaData;

	if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
		return -1;
	}

	listenScoket = socket(AF_INET, SOCK_STREAM, 0);
	if (listenScoket == INVALID_SOCKET) {
		return -1;
	}

	SOCKADDR_IN servAddr;

	ZeroMemory(&servAddr, sizeof(servAddr));
	servAddr.sin_family = AF_INET;
	servAddr.sin_port = htons(PORT);
	servAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);

	if (bind(
		listenScoket,
		(SOCKADDR*)&servAddr,
		sizeof(servAddr)) == SOCKET_ERROR) {
		closesocket(listenScoket);
		return -1;
	}
	retval = listen(listenScoket, SOMAXCONN);
	if (retval == SOCKET_ERROR)
		printf("listen() Error");

	SOCKET clientSocket;
	SOCKADDR_IN clientAddr;
	int length;
	char buf[BUFSIZE + 1];

	while (true) {
		length = sizeof(clientAddr);
		clientSocket = accept(listenScoket, (SOCKADDR*)&clientAddr, &length);
		
		if (clientSocket == INVALID_SOCKET) {
			printf("accept() Error");
			continue;
		}

		printf("\n [TCP server] 클라이언트 IP 주소 = %s, Port = %d\n",
			inet_ntoa(clientAddr.sin_addr),
			ntohs(clientAddr.sin_port));

		while (true) {
			retval = recv(clientSocket, buf, BUFSIZE, 0);
			//얘는 클라이언트로부터 입력받은 버퍼(문자열) 길이가 된다..

			if (retval == SOCKET_ERROR) {
				printf("recv() error");
				break;
			}
			else if (retval == 0) {
				break;
			}

			buf[retval] = '\0';
			printf("[TCP %s : %d] %s\n", inet_ntoa(clientAddr.sin_addr), ntohs(clientAddr.sin_port), buf);
			retval = send(clientSocket, buf, retval, 0);
			if (retval == SOCKET_ERROR) {
				printf("send() error");
				break;
			}
		}
		closesocket(clientSocket);
		printf("[TCP server] 클라이언트 종료: IP주소 = %s, Port = %d\n",
			inet_ntoa(clientAddr.sin_addr), ntohs(clientAddr.sin_port));

	}
	closesocket(listenScoket);
	WSACleanup();
	return 0;
}