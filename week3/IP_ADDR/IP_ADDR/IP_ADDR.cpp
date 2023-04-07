#pragma comment (lib, "ws2_32.lib")
#include <WinSock2.h>
#include <stdio.h>
#include <ws2tcpip.h>


/*
	마주한 에러 1.
	inet_addr()를 사용했는데 에러가 발생했다. 마주한 에러1사진.
	그래서 대안 방법으로 inet_addr()사용하지 않고 inet_pton()를 사용하기로 했다.
	이 함수은
	#include <arpa/inet.h> 이 헤더파일에 정의 되어 있어서 추가로 선정해줬다.
	그런데 윈도우 용은 이 헤더파일마저 불러와지지 않는다.
	그래서 #include <ws2tcpip.h>를 사용했다.

	마주한 에러2.
	inet_ntoa 이 함수도 더이상 사용하지 말라고 권장되서
	inet_ntop()함수를 사용하라고 inet_ntop()를 사용하라고 권장되어있다.
*/

int main(void) {
	WSADATA wsa;
	if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
		return -1;
	}

	//ip 주소 출력
	const char* servIP = "0.000.000.100";
	printf("IP 주소 = %s\n", servIP);

	//inet_addr() 함수
	printf("IP 변환주소 = 0x%x\n", inet_addr(servIP)); // sdl검사 아요
	//https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=luckywjd7&logNo=220872794096
	
	//inet_ntoa()
	IN_ADDR temp;
	temp.S_un.S_addr = inet_addr(servIP);
	printf("IP 변환 주소 = %s\n", inet_ntoa(temp));

	//윈속 종료
	WSACleanup();
	return 0;
}