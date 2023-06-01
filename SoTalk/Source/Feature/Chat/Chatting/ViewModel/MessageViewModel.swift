//
//  MessageViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class MessageViewModel {
  // MARK: - Properties
  let data = [
    CommentModel(uid: "1", comment: "앱개발자 될끄야!!!! 앱으로 대박나야지\n This is me!!!!!! 난 럭키가이", username: "아만나가먹고싶다", profileImageUrl: "4"),
    CommentModel(uid: "5", comment: """
맥주 줄여야겠다. 마지막으로 한잔?
그 전에 맥주 세계 선호도 5위까지 브랜드를 지삐티한테 물어봤어
1.안하우저-부쉬 (Anheuser-Busch) - 버드와이저 (Budweiser), 코르스 (Corona), 스텔라 아르투아 (Stella Artois) 등을 포함한 다양한 맥주 브랜드를 보유하고 있습니다.
2. 하이네켄 (Heineken) - 네덜란드 출신의 세계적인 맥주 브랜드로 유명합니다.
3. 까스테인 (Carlsberg) - 덴마크에서 시작된 맥주 브랜드로, 국제적으로 알려져 있습니다.
4. 게롤슈 (Grolsch) - 네덜란드의 전통적인 맥주 브랜드로 유명하며, 그롤슈 플립탑 병이 특징입니다.
5. 길더 (Guinness) - 아일랜드에서 시작된 스타우트 맥주로, 짙은 색과 부드러운 맛으로 유명합니다.
올 그래도 내가 아는거 두 개 있네 버드와이저, 하이네켄 (요곤 약간 특이한 향이 있떤데)
""",
                 username: "지피티 할루시네이션 빼면 진짜 초대박", profileImageUrl: "8"),
    CommentModel(uid: "6", comment: "벌써 기말이라니;;;", username: "롯데리아버거킹짱", profileImageUrl: "4"),
    CommentModel(uid: "7", comment: "맥주 줄여야겠다.\n하하하하", username: "짱구를 잘말려", profileImageUrl: "8"),
    CommentModel(uid: "8", comment: "모두 화이팅..", username: "나는야 취준생", profileImageUrl: "8")]
  
}

extension MessageViewModel: MessageViewControllerDataSource {
  var numberOfItems: Int {
    data.count
  }
  
  func cellForRowAt(_ indexPath: IndexPath) -> CommentModel {
    return data[indexPath.row]
  }

}
