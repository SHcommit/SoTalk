#pragma comment( lib, "ws2_32.lib")

#include <WinSock2.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

bool GetIPAddr(const char* name, IN_ADDR* addr) {
	HOSTENT* ptr = gethostbyname(name);
	if (ptr == NULL) {
		return false;
	}
	memcpy(addr, ptr->h_addr, ptr->h_length);
	return true;
}

bool GetDomain(IN_ADDR addr, char* name) {
	HOSTENT* ptr = gethostbyaddr((char*)&addr, sizeof(addr), AF_INET);
	if (ptr == NULL) {
		return false;
	}
	strcpy(name, ptr->h_name);
	return true;
}

int main() {
	WSADATA wsa;
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
		return -1;

	// 도메인 이름 -> IP주소 출력
	IN_ADDR addr;
	if (GetIPAddr("a.com", &addr)) {
		printf("url: yahoo.com\n");
		printf("IP 주소 = %s\n", inet_ntoa(addr));

		//IP주소 ->도메인 이름
		char name[256];
		if (GetDomain(addr, name)) {
			printf("도메인 이름  = %s\n", name);
		}
	}
	WSACleanup();
	return 0;
}