//
//  MockGroupModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

struct MockGroupModel {
  let defualtImage = UIImage(named: "defaultImage")?.compressJPEGImage(with: 0)
  
  private let imageNames = (1...6).map { "tempGruopViewCellImage\($0)"}
}

extension MockGroupModel {
  private func makeImage(_ index: Int) -> UIImage? {
    return UIImage(named: imageNames[index])?.compressJPEGImage(with: 0)
  }
  
  func mockData() -> [GroupModel] {
    return [
      .init(groupId: 0, groupName: "카페/맛집/디저트 수다방", gorupImage: defualtImage),
      .init(groupId: 1, groupName: "넷플 드라마, 여행 잡담", gorupImage: makeImage(1)),
      .init(groupId: 0, groupName: "IT 개발자 구직/채용 정보 교류방", gorupImage: makeImage(3))]
  }
}
