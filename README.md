# NetworkSocketProgrammingWithSwiftBsd
TCP 기반 네트워크 통신~.~

완전 신기.. 다른 컴퓨터와도 통신이 가능하다니..

주로 c언어로 배운 socket에 사용될 함수들 listne(), bind(), recvfrom()... socket programming을 위해 c언어로 수업과 함께 학습한 후 swift언어로 변환하는 작업을 거쳤습니다. UnsafePointer나 UnsafeMutablePointer.. 이런 타입의 형변환을 해주는 함수 withundsafemutablepointer(to:_:), socket 통신을 위해 리틀 -> 빅 인디안으로, 또는 서버로부터 받아온 값을 내 컴퓨터에서 사용하기 위해 빅 -> 리틀 인디안으로 바꾸는 과정 등 을 swift로 구현했습니다.

- udp 클라이언트 앱에 기능 적용시커 에코로 서버에 socket과 함께 데이터 전달했는데 잘 동작됩니다.
- 아래 이미지는 testUDPSocketClient 소스코드 실행 결과입니다.

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/96910404/231866211-50ffc5d3-4f86-4425-8ff8-5aef16764c62.gif)
