# Check plus plus

<a href="https://www.youtube.com/watch?v=cr2EiR9jQEs">
<img src = "https://i3.ytimg.com/vi/cr2EiR9jQEs/maxresdefault.jpg" width = 600/>
</a>

⬆ 이미지를 클릭하시면 앱 소개 영상으로 이동합니다.(Youtube link)

['스마트한 당신이 더 스마트해지기 위한 방법 - 췤'](https://github.com/hngfu/todo-check)보다 한걸음 더 진보한 앱  
서버와 연결되었다!

- 핸드폰을 바꿔도 지속적으로 사용 가능
- iOS뿐만 아니라 다양한 플랫폼과의 연동이 가능(예정)

## 여러 생각한 것들

<details>
  <summary>만든 목적</summary>
  <div markdown="1">

이전에 만든 [마스크앱](https://github.com/hngfu/mask-app)이 타인을 위한다는 숭고한 정신, 마음으로 만든 앱이라면  
이번 앱(췤++)은 취업하는 데 도움이 되었으면 하는 마음과, 학습했던 내용들 복습 겸, 재미있을 것 같다고 생각한 부분이 있어서 만들게 되었다.

  </div>
</details>

<details>
  <summary>iOS</summary>
  <div markdown="1">

### 좋은 코드

미래엔 기준이 발전하여 바뀔 가능성이 다분하지만 나에게 좋은 코드란 '협업하기 좋은 코드'다.  
협업하기 좋은 코드의 기준은

1. 읽기 쉽다. -> 네이밍, 주석을 적절한 곳에 적절하게 사용하고, 객체의 책임과 역할을 확실히 하여 구현한다.
2. 실수하기 어렵다. -> 문자열로 그냥 쓰는 것보다 자동완성 기능을 사용하도록 변수 등을 지향하고, 접근 제한자를 잘 사용한다.

정도가 지금은 생각난다.

그리고 이 밖에 나만의 여러 기준들을 가지고 구현을 했다.

### 아키텍쳐

아키텍쳐 패턴은 MVVM-C를 사용했다.  
인터넷에 돌아다니는 몇몇 MVVM-C 패턴을 참고하고  
Uber의 RIBs 프레임워크를 많이 참고해서 구현했다.

MVVM-C를 사용한 이유는 Storyboard 환경에서는  
다른 패턴보다 직관적이라고 생각하고 여러 상황에 가장 유연하게 대처 가능하다고 생각해서였다.  
<strike>사실 MVC도 너무너무 좋지만 전에 많이 써봐서 MVVM-C가 더 끌렸다.</strike>

### Protobuf

소켓 통신을 할 때 서버와 클라이언트의 패킷 형식을 일치시키는 게 중요한데  
XML을 읽어서 패킷 파일들을 만들어주는 Packet Generator를 만들까 했는데  
Google Protobuf란 게 있었고 Apple에서도 Google Protobuf와 호환되는 Swift Protobuf를 지원하고 있어서  
Protobuf를 사용하게 되었다.

  </div>
</details>

<details>
  <summary>Server</summary>
  <div markdown="1">

### Firebase

회원가입을 직접 구현할까 했었다.  
하지만 직접 구현하려면 아이디 찾기, 비밀번호 재설정이 필요하고  
그러면 개인 정보도 더 수집해야 하고(아이디 찾기 위한 단서), 비밀번호 재설정 이메일 발송 기능도 추가해야 하고  
구현할게 자꾸 늘어난다고 생각했다.
그래서 Firebase를 사용해서 간단하게 OAuth를 이용한 회원가입을 구현하게 되었다.

### 아쉬웠던 점

namespace을 잘 활용해서 구역을 잘 나눠서 개발하고  
전에 학습했던 DDD의 개념들

1. Presentation Layer, Application Layer, Domain Layer를 잘 나눠서 개발하기
2. CQRS(Command Query Resposibility Segregation)
3. Micro Architecture

등을 적용해보고 싶었지만  
앱의 기능이 위의 개념들의 적용이 필요할 정도로 많지 않은 등  
여러 가지 여건 문제로 적용 못했다.  
나중에 친구와 토이 프로젝트를 하게 되면 적용해봐야겠다.

  </div>
</details>

<details>
  <summary>Database</summary>
  <div markdown="1">

<img src="https://user-images.githubusercontent.com/38850628/116001615-3d2e0800-a630-11eb-996f-317215dae265.PNG" width="800"/>

### DB 구조

지금 앱을 보면 한 사람이 하나의 리스트만 가지도록 되어있다.  
하지만 향후에 한 사람이 여러 리스트를 가질 수 있고 가지고 있는 리스트를 다른 사람에게 공유할 수 있도록 업데이트할 계획이 있어서  
결국 User가 List를 여러 개 가질 수 있고 List도 User를 여러 개 가질 수 있는 다대다 관계가 생기게 되었다.  
그래서 다대다 관계를 풀어주기 위해 Users와 ToDoLists 사이에 Users_ToDoLists 엔티티를 추가해 주었다.

### 인덱스

원래 처음에 MSSQL로 로컬에서 만들고 테스트하다가 AWS에 MSSQL을 추가하려니까 MSSQL은 프리티어가 없었다.  
그래서 프리티어가 있던 것 중에 MySQL을 골라서 구현했는데 와.. 진짜 SQL이라고 둘이 비슷할 거라고 생각했는데  
Clustered Index, Non-clustered Index 설정하는 게 둘이 달라서 많이 당황했었다.  
예를 들어 MSSQL은 Primary Key가 Clustered Index가 아닐 수 있지만  
MySQL은 Primary Key가 무조건 Clustered Index였다.  
결국 잘 해결하고 Query, Command 문에 적절한 Index를 설정해 줬다.

  </div>
</details>

<details>
  <summary>AWS</summary>
  <div markdown="1">

<img src="https://user-images.githubusercontent.com/38850628/116002057-bcbcd680-a632-11eb-9b1b-0108f7a491fb.png" width="800"/>

### 서버 선택

서버를 어떻게 구현할까 고민을 했었다.

1. 클라우드 서비스를 사용할까?
   - AWS? Azure? GCP? Firebase?
2. 특정 디바이스를 사용할까?
   - Desktop? raspberry pi? used laptop? used android phone??

먼저 클라우드를 사용하면 여러모로 편하고 장점이 많을 것 같았다.  
(여러 상황에 유연하게 대처 가능, 서비스를 더욱 이롭게 만들어주는 기능 등)  
하지만 어떠한 변수가 발생하여 비용이 얼마나 청구될지 모르기 때문에  
그 불확실함이 나를 더 고민하게 만들었다.

반면 특정 디바이스를 사용한다는 것은
클라우드 서비스보다 더욱 예측 가능하고 나에게 안정감을 주었다.
그래서 그중에 무엇을 사용할까 고민했다.

- Desktop

  - <장점>
  - 성능이 좋다.
  - <단점>
  - 항상 Desktop을 켜놔야 한다. -> 잘 때 켜져 있는 Desktop을 생각하면 달갑지 않다.
  - 전기세 -> 모니터를 꺼놓으면 많이 발생하진 않을 거라 생각되지만 어쨌든 추가 비용이 발생한다.

- raspberry pi

  - <장점>
  - 충분한 성능 (이전 세대에 비해 요즘 성능이 많이 좋아졌다)
  - 스마트 홈을 구축할 계획이 있었는데 겸사겸사 사용 가능
  - 위의 Desktop 단점을 커버할 수 있다.
  - 항상 켜놔도 나의 시각, 청각의 역치 값을 넘기지 못하는 수준이다.
  - 전기도 조금 사용하기 때문에 전기세도 거의 나가지 않는다.

- used laptop

  - <단점>
  - 집에 사용하지 않는 laptop의 소음이 너~무 심하다.
  - 전기세

- used android phone

  - <단점>
  - 구매해야 함
  - 확장하기 안 좋음
  - '직감'이란 예리한 고찰이 쌓이고 쌓여 발상 되는 것이라고 들었다.
  - 나의 '직감'이 거부

그래서 raspberry pi를 사용하려고 했었다.
그런데 막상 또 생각해 보니

- 인터넷 통신사 약관에 어긋날 가능성
- 디바이스 관리(열기 처리 등)
- 여러 보안 문제 등

디바이스를 사용할 때의 귀찮음이 클라우드를 사용할 때의 불확실성보다 컸다..!
그리고 또 생각해 보니 AWS 프리티어가 남아서 어떻게 잘 사용하면 비용을 많이 줄일 수 있을 것 같았고
이 기회에 AWS를 좀 더 제대로 사용하면 불확실성이 줄어들고 확실성이 늘 것 같았다.

그리고 클라우드 서비스에서는 AWS, Azure, GCP 중에서는
지금 내 앱에 필요한 서버 수준에서는 셋 다 비슷할 것 같아서
AWS를 사용하기로 결정했다.

  </div>
</details>

<details>
  <summary>유튜브 동영상</summary>
  <div markdown="1">

### 파이널 컷 프로

전에 애프터 이펙트를 잠깐 학습했었던 덕분 + 직관적인 파이널 컷 프로의 인터페이스 덕분에  
짧은 시간에 괜찮은 동영상을 만들 수 있었다.

### 음악 100개

좋은 영상을 만들기 위해 좋은 BGM을 설정해야 했고 좋은 BGM을 위해 100개가 넘는 음악들을 찾아 헤매면서  
영상과 적절한 음악을 찾았다.

### 썸네일

타이다이(Tie-dye)에 영감을 받아서 만들었다.

  </div>
</details>
