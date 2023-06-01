//
//  MessageCell.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

extension MessageCell {
  static let id: String = String(describing: MessageCell.self)
  
  enum Constant {

    // 여기서 나인지 상대인지에 따라 spacing이 달라야함.
    // 카카오톡 대화창 대충 자로 재봤는데 상대 1 : 5 : 1.5 비율
    // 나는 2.5 : 5
    enum Me {
      enum MessageContentView {
        static let spacing: UISpacing = {
          let screenWidth = UIScreen.main.bounds.width
          let leadingSpacing = screenWidth/7.5 * 2.5
          return .init(leading: leadingSpacing, top: 7, trailing: 7, bottom: 7)
        }()
      }
    }
    
    enum Other {
      enum Profile {
        static let size = CGSize(width: 40, height: 40)
        static let spacing = UISpacing(leading: 7, top: 7)
      }
      
      enum MessageContentView {
        static let spacing: UISpacing = {
          let screenWidth = UIScreen.main.bounds.width
          let trailingSpacing = screenWidth/7.5 * 1.5
          return .init(leading: 7, top: 7, trailing: trailingSpacing, bottom: 7)
        }()
      }
      
    }
    
  }
}

final class MessageCell: UICollectionViewCell {
  
  // MARK: - Properties
  private let profile = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Constant.Other.Profile.size.width/2
    $0.clipsToBounds = true
  }
  
  private let messageContentView = MessageContentView()
        
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .brown
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension MessageCell {
  func configure(with data: CommentModel) {
    
  }
}

// MARK: - LayoutSupport
extension MessageCell: LayoutSupport {
  func addSubviews() {
    _=[profile, messageContentView].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    <#code#>
  }
  
  
}
