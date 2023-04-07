#pragma comment (lib, "ws2_32.lib")

#include <winsock2.h>
#include <stdlib.h>
#include <stdio.h>

const u_short BUFSIZE = 512;
const u_short PORT = 9000;

int main() {
	int res;

	WSADATA wsa;
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) { return -1; }

	SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);
	SOCKADDR_IN schoolBroadaddr;
	ZeroMemory(&schoolBroadaddr, sizeof(schoolBroadaddr));
	schoolBroadaddr.sin_family = AF_INET;
	schoolBroadaddr.sin_port = htons(PORT);
	schoolBroadaddr.sin_addr.S_un.S_addr = inet_addr("000.00.000.000");
	BOOL bEnable = TRUE;
	res = setsockopt(
		sock,
		SOL_SOCKET,
		SO_BROADCAST,
		(char*)&bEnable,
		sizeof(bEnable));

	if (res == SOCKET_ERROR) {
		printf("Socket option set : (%d)\n", WSAGetLastError());
		return -1;
	}




	SOCKADDR_IN remoteAddr;
	ZeroMemory(&remoteAddr, sizeof(remoteAddr));
	remoteAddr.sin_family = AF_INET;
	remoteAddr.sin_port = htons(PORT);
	remoteAddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);

	char buf[BUFSIZE + 1];
	int len;

	while (true) {
		printf("\n전송데이터");
		if (fgets(buf, BUFSIZE + 1, stdin) == NULL) break;

		len = strlen(buf);
		if (buf[len - 1] == '\n') buf[len - 1] = '\0';
		if (strlen(buf) == 0) break;

		//original
		res = sendto(
			sock,
			buf,
			strlen(buf),
			0,
			(SOCKADDR*)&remoteAddr,
			sizeof(remoteAddr));

		if (res == SOCKET_ERROR) {
			printf("Send data : Fail(%d)\n", WSAGetLastError());
			continue;
		}

		//이거는 학교에 서버!!!에 브로드캐스트리시버 한테 보내는 코드
		res = sendto(
			sock,
			buf,
			strlen(buf),
			0,
			(SOCKADDR*)&schoolBroadaddr,
			sizeof(schoolBroadaddr));

		if (res == SOCKET_ERROR) {
			printf("Send data : Fail(%d)\n", WSAGetLastError());
			continue;
		}

		printf("%d byte 전송\n", res);
	}
	closesocket(sock);
	WSACleanup();
	return 0;
}