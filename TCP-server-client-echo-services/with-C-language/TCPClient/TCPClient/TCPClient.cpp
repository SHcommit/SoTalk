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
	int recval;
	SOCKET clientSocket;
	WSADATA wsa;

	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
		printf("WSAStartup Error \n");
	}

	clientSocket = socket(AF_INET, SOCK_STREAM, 0);

	if (clientSocket == INVALID_SOCKET) {
		printf("socket() Error \n");
	}

	SOCKADDR_IN clientAddr;
	clientAddr.sin_family = AF_INET;
	clientAddr.sin_port = htons(PORT);
	clientAddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");

	printf("client Addr %d\n", clientAddr.sin_addr.S_un.S_addr);
	// 1. 연결
	recval = connect(clientSocket, (SOCKADDR*)&clientAddr, sizeof(clientAddr));
	if (recval == SOCKET_ERROR) {
		printf("connect()");
	}

	char readBuffer[BUFSIZE + 1];
	int length;

	while (true) {
		ZeroMemory(readBuffer, sizeof(readBuffer));
		printf("\n [전송 데이터]");
		if (fgets(readBuffer, BUFSIZE + 1, stdin) == NULL) {
			break;
		}
		//입력 받고
		length = strlen(readBuffer);
		if (readBuffer[length - 1] == '\n') {
			readBuffer[length - 1] = '\0';
		}
		if (strlen(readBuffer) == 0) {
			break;
		}
		//send로 전송
		recval = send(clientSocket, readBuffer, strlen(readBuffer), 0);
		if (recval == SOCKET_ERROR ){
			printf("send()");
			break;
		}
		printf("[TCP 클라이언트] %d 바이트를 보냈습니다.\n", recval);
		recval = recv(clientSocket, readBuffer, recval, 0);
		if (recval == 0) {
			break;
		}
		readBuffer[BUFSIZE] = '\0';
		printf("[TCP 클라이언트] %d 바이트를 받았습니다.\n", recval);
		printf("[받은데이터] %s\n", readBuffer);
	}
	closesocket(clientSocket);
	WSACleanup();

	return 0;
}