# SoTalk 💬

### 네트워크 학기말 과제: TCP 통신, UDP통신등 Socket을 사용한 채팅기능 관련 서비스 만들기 :]

#### Duration: 2023.05.25 ~ 2023.06.12 ( 19 Days )

## 🎯 프로젝트 목표

- 회원가입, 로그인 기능
- 프로필 저장, 업데이트 기능 (삭제 기능 미완)
- 그룹 검색 기능
- 메인 화면
- 그룹 채팅 기능 (with **TCP** socket :)
- 기타 애니메이션
- Without third party !!

## 👥 팀원 소개

|iOS: 양승현|BE: 임경완|
|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/96910404?s=400&u=9e3d914e4168c78643e358115a0294669793ca99&v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/47065431?v=4" width=150>|
|[@SHcommit](https://github.com/SHcommit)|[@MoonDooo](https://github.com/MoonDooo)|


## ✨ 작동 화면

<img src="https://github.com/SHcommit/SoTalk/assets/96910404/54941c39-7a5e-4760-8aa3-7c25384ad80b" width="350">|<img src="https://github.com/SHcommit/SoTalk/assets/96910404/d26f2c66-57d9-4f2b-8695-7f706c063935" width="350">|
|:-:|:-:|
|`회원가입`|`로그인+프로필 이미지 변경`|


<img src="https://github.com/SHcommit/SoTalk/assets/96910404/21e7efb9-819d-42f7-b826-88e8e682f052" width="350">|<img src="https://github.com/SHcommit/SoTalk/assets/96910404/c12d0e59-8db1-4125-baea-7b97b555b95b" width="350">|
|:-:|:-:|
|`그룹 채팅 추가 기본 기능`|`그룹 추가 기능`|

<img src="https://github.com/SHcommit/SoTalk/assets/96910404/b083ca26-0fae-4ea2-a8ef-a26f03cf311c" width="350">|<img src="https://github.com/SHcommit/SoTalk/assets/96910404/4c606b74-68de-47c6-8661-02daef1bae44" width="350">|
|:-:|:-:|
|`Carousel effect`|`서버 연동 전 채팅`|


<img src="https://github.com/SHcommit/SoTalk/assets/96910404/17d8bbe8-856a-4e6a-91bf-d85b8ee19cfc" width="900">|
|:-:|
|`TCP Socket 연동 후 채팅 방`|


<img src="https://github.com/SHcommit/SoTalk/assets/96910404/271a6fb5-766c-416a-bcec-a6f73a5d613a" width="900">|
|:-:|
|` TCP Socket으로 채팅중 send, recv ... :) `|



## 📚 Tech stack
 
<details>
<summary>👨‍💻 iOS Tech stack</summary>

### 1st party

- UIKit

- GCD

- AutoLayout

### 3rd party

- SwiftLint

- Lottie
</details>


## 🔭  프로젝트 구조: MVVM+C

![스크린샷 2023-06-27 오전 12 20 07](https://github.com/SHcommit/SoTalk/assets/96910404/f40e66a7-5b5c-4c5e-98a4-e3cd886edc65)

- clean architecture + MVVM을 사용하려 했으나 굳이 use case정의 없어도 될 것 같아 UseCase를 제외한 Clean architecture를 적용했습니다.

- ViewController와 ViewModel간 Input/Output binding을 사용해 비즈니스로직과 UI관련 처리를 분리했습니다.

- 서버 연동 전까지 Mock data 사용이 용이했습니다.


## 🔭  Coordinator pattern

<img src="https://github.com/SHcommit/SoTalk/assets/96910404/73b0b825-db4b-445f-9149-4e8f0eec325e">

- 로그인 후 메인 화면으로 갈 때 Coordinator 패턴을 사용하지 않았다면 델리게이트로 SceneDelegate.swift에서 루트 윈도우를 교체했을 것입니다. 하지만 Coordinator 패턴을 사용하면서 parent, child의 관리만 잘해준다면, 그리고 특정 화면에서 다른 화면으로 넘어갈 경우를 Coordiantor 안에 정의해 준다면 더욱 편리하게 화면 전환을 관리할 수 있겠다고 생각해서 Coordinator 패턴을 도입했습니다.

- 메인 홈에서, 사이드 메뉴와 사이드 메뉴에서 발생되는 여러 화면 전환 컨트롤러들을 관리하기 용이했습니다.
- ViewController에서 화면 전환의 부담을 줄였습니다.

---

## 🗺  새로 알게된 개념, 기존에 학습했던 개념

- Side menu

> 예전에 <a href="https://github.com/SHcommit/Swift-Study">친절한 재은씨 실전편</a>에서 공부했던 Side menu 정말 어렵게 느껴졌지만, 그럼에도 third party를 사용하지 않고 구현했던 경험이 있습니다. 그러면서도 side menu가 show됬을 때 기존에 있는 메인 화면이 터치되서 메모장을 동시에 작성하는 그런 오류를 발견하고도 수정하지 못했었던 기억도 있습니다. 
 
> 이번에 다시 새롭게 구현하면서 CGAffineTransform의 위대함을 다시 느꼈고 이전에는 해결하지 못했던 그런 에러들을 손쉽게 해결할 수 있었습니다. 

- FirstResponder | InputAcecssoryView
> 아주 예전에 인스타 그램 개발할 때 UIResponder관련해서 공부를 했었는데 그새 까먹었지만 다시 완벽하게 알게 되었습니다. 

> 이번 프로젝트에서 또 탄탄하게 알게된 개념 중 하나는 InputAccessoryView입니다. 토스의 1 thing 1page를 본따서 회원가입 기능을 만들어보고 싶었습니다. 이때 회원가입에서의 1thing은 컴포넌트가 화면에서 너무 작은 영역에 속했기에 고민이 많았지만 InputAccessoryView와 firstResponder를 유지하며 화면의 빈 공백을 채웠습니다. 

> 더 나아가 서버에서 지정한 일정 텍스트 이상을 입력하거나 입력하지 않았을 때, 다음 버튼이 잠기고 일정 입력을 넘겼을 때 겉 테두리의 변화 등의 감지 기능을 새롭게 커스텀해서 추가했습니다.

- UINavigationBar

> 이전까지 개발하면서 status bar와 네비게이션 바는 필수적으로 해당 영역 안에  추가해서 사용되야 한다고 생각했습니다. 그러나 지금과 같은 홈 화면을 구현할 때 navigation bar에 subview로 넣게 된다면 SafeAreaLayoutGuide가 인지하지 못해서 오토레이아웃의 top영역 레이아웃 잡기가 힘들어 질 것이고.. 커스텀 네비바를 만들어도 애초에 네비게이션 바의 기본 크기가 44?로 정해져 있기에 다른 방법이 필요했습니다. 도저히 해결 방법을 몰랐고, iOS개발 단톡방에 질문했었는데 유쾌하게 .. 안쓰면 되는거 아니냐는 답변이.. (아하)

- Chatting UI

> 채팅 기능을 처음에 구현하려고 했을 때 화면 구성을 어떻게 해야할지 막막하면서도 예전에 봤던 <a href="https://engineering.linecorp.com/ko/blog/ios-refactoring-uicollectionview-1">라인 message cell colllectionView로 리펙터링 한 글</a>이 떠올랐고 이와, 카카오톡의 UI를 본따서 만들게 되었습니다. 라인의 글을 보니 정말 많은 기능들을 구현했음을 알 수 있었습니다. 시간적 여유가 있다면 계속해서 추가 기능을 개발하고 싶은데 지금 더 대박인 앱을 개발중에 있어서.. (시간이 48시간이었으면 좋았을텐데.. :)

- Multipart form-data

>  으으... 기존에 개발할 때 base64를 썼었다가 인스타그램 개발하면서 파이어베이스에서 지원되는 함수를 사용했고 firesbase의 storage에서 url을 불러왔었습니다. 이번에 처음으로 Multipart 형식으로 이미지를 requset해야 했었습니다. 정말 어려웠는데.. 그럼에도 서버측에선 기능을 이미 구현했기에... 

> 이번에 새롭게 접한 Multipart 도 계속해서 코드를 보니 익숙해져 버렸습니다. boundary를 사용하면서 서버에서 요구했던 json data를 양식에 맞게 여러 파트로 나눠서 보내면 되는 것이었습니다. (처음이 어렵지..)

- HTTP/HTTPs header, body param, method, query param... Endpoints | Encodable, Decodable

> 기존 https 통신은 그저 영화 정보를 가져온다던지, 뉴스 정보를 가져온다던지 등 + 내가 원하는 정보만 Decodable로 mapping해서 받아오면 끝이었습니다. 그리고 파이어베이스를 5개월간 사용했었는데,, 이번 기회에 서버랑 통신을 하면서 처음으로.... post도 method로 body param도 넣어보고 get으로 query param도 넣는 경험을 했었습니다. 이전에는 Codable을 왜 정의했을까? (주로 Decodable 만 사용했었기 때문입니다.) 이번 서버와의 통신을 통해 Encodable은 request!!! Decodable은 response라는 것을 정확히 알게 됬고 왜 Decodable은 init으로 시작되는가? 에대한 해답을 자연스레알게 되었습니다. "서버에서의 data를 Decodable타입의 모델 각각의 인스턴스에 값을 넣기 위해 init을 사용한다는..." 우와.. 정말 프로토콜 잘 지었다는 생각이..

> Endpoints는 Clean architecture에서도 정의를 했는데 김종권님이 정의한 것에 추가적으로 Multipart form data request형식을 추가해서 프로젝트에 적용했습니다.

## 🧭 느낀점

- TCP 통신을 설계할 때 화면 단에서는 스크롤이나 키보드 입력과 같은 user interactive관련 작업을 수행해야합니다. 이와 동시에 TCP의 recv()는 서버로부터 다른 유저가 보낸 send()를 언제든지 listening을 해야 합니다.

<img src="https://github.com/SHcommit/SoTalk/assets/96910404/58e6f442-51ad-4cd5-8e6f-0cf31cae25b3">

그룹방의 Socket에 connect하기 위한 서버 개발자가 정한 초기 규칙을 준수 할 경우 성공적으로 serv socket으로부터 recv를 할 수 있게 됩니다. 위에서 언급한 경우 때문에 background thread를 활용해 recv()함수는 계속해서 listening상태를 유지하고, 사용자의 입력이 있을 경우에만 서버한테 send()를 보내는 로직을 구현했습니다.

Restful 통신을 할 때는 클라이언트 단에서 request가 있어야만 server측에서 response를 합니다. 그래서 저는 예전에 인스타 그램 개발을 할 때, 채팅 기능을 구현할 때 게시글 처럼 위로 당겨서 refresh를 해야만 타 유저가 남긴 글을 볼 수 있었습니다. 이와 반면 Socket 통신은 recv()를 활용해서 서버의 다른 유저가 send() 할 경우 recv()중인 클라이언트한테 타 유저가 보낸 글을 다른 클라이언트에게도 전송할 수 있다는게 정말 신기했고 이 기능을 생각해낸 경완이도 대단하다고 생각했습니다. 

- 이 날을 위해 Socket관련 개념들을 공부하며 구현했던 TCP, UDP serv, client ...등 C언어로 구현했던 프로젝트를 그대로 Swift로 혼자 구현했었는데 그 보람이 있었던 것 같았습니다. BSD socket 자체가 C언어로 개발된 거라 이를 wrapping한 함수를 사용하기 위해선 withUnsafePointer()등 처음 접하는 함수들을 사용할 줄 알아야 했고 새롭게 학습하게 되었습니다.

- 길다면 길고 짧은 기간이었지만,, 정말 많은 새로운 기능들을 학습하며 적용해 나갔습니다. 이론으로 공부하며 어림잡아 알고 있었던 애니메이션과 이론으로 공부만 했었던 Clean architecture, 브랜디에서 제공한 datasource, delegate를 다루는 adapter pattern 등 다양한 이론을 실제로 적용하면서 지식들이 친근해진 것 같습니다.

-  이 TCP 프로젝트는 교수님이 아무 언어나 사용해도 된다고 하셨기에 Swift를 사용할 수 있어 정말 재밌을 것 같았습니다. 하지만 초기 화면에 UI를 채워 넣을 데이터가 너무 없어서 막막했었습니다. 그래서 부족한 부분들은 애니메이션들을 부분 부분 적용해서 시선을 이끌려고 시도했습니다.

- Carousel 관련 기능 개발은 세로로도 해보고 가로로도 해봤고 블로그에 3편 정도 정리를 했습니다. 이번에는 collectoinView의 contentInset을 넣었고 이 경우는 또 처음이기에 또 새로운 벽을 만났습니다. 그러면서 새로 알게된 점은 scrollView.content.x는 collectionView의 content inset를 인지하지 못한다는 것이기에 contentinset.leading의 값만큼 빼야했고, collectionView.contentSize.x의 끝 부분도 마찬가지였습니다. 이부분이 정말 까다롭다는 것을 또 이렇게 새로 경험했습니다.
