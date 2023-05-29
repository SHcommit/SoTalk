//
//  ChatListLeftNaviItem.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit
import Lottie

extension ChatListLeftNaviItem {
  enum Constant {
    enum BottleView {
      static let size = CGSize(width: 80, height: 80)
      static let imageName = "bottle"
      static let spacing: UISpacing = .init()
    }
    enum userNameLabel {
      static let spacing: UISpacing = .init(leading: 0)
      static let fontSize: CGFloat = 16
    }
  }
}

final class ChatListLeftNaviItem: UIView {
  // MARK: - Properties
  let bottleView = LottieAnimationView(name: Constant.BottleView.imageName).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.loopMode = .loop
    $0.contentMode = .scaleAspectFit
  }
  
  var userNameLabel: UILabel!
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(with userName: String) {
    self.init(frame: .zero)
    initUserNameLabel()
    configure(with: userName)
    setupUI()
    bottleView.play()
  }
}

// MARK: - Private helpers
extension ChatListLeftNaviItem {
  func configure(with name: String) {
    let attrString = NSMutableAttributedString(
      string: "Hello,\n\(name)님!")
    let hiAttrStr: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(
        ofSize: Constant.userNameLabel.fontSize),
      .foregroundColor: UIColor.Palette.primaryHalf]
    
    let userNameAttrStr: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(
        ofSize: Constant.userNameLabel.fontSize),
      .foregroundColor: UIColor.Palette.primary]
    _=[
      (hiAttrStr,
       NSRange(location: 0, length: 6)),
      (userNameAttrStr,
       NSRange(location: 7, length: name.count+2))]
      .map { attrString.addAttributes($0, range: $1) }
      
    userNameLabel?.attributedText = attrString
  }
  
  func initUserNameLabel() {
    userNameLabel = UILabel().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.numberOfLines = 2
      $0.textAlignment = .left
    }
  }
}

// MARK: - LayoutSupport
extension ChatListLeftNaviItem: LayoutSupport {
  func addSubviews() {
    _=[bottleView, userNameLabel].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[menuViewConstraints, userNameLabelConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

private extension ChatListLeftNaviItem {
  var menuViewConstraints: [NSLayoutConstraint] {
    [bottleView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.BottleView.spacing.leading),
     bottleView.centerYAnchor.constraint(equalTo: centerYAnchor),
     bottleView.heightAnchor.constraint(
      equalToConstant: Constant.BottleView.size.height),
     bottleView.widthAnchor.constraint(
      equalToConstant: Constant.BottleView.size.width)]
  }
  var userNameLabelConstraints: [NSLayoutConstraint] {
    [userNameLabel.leadingAnchor.constraint(
      equalTo: bottleView.trailingAnchor,
      constant: Constant.userNameLabel.spacing.leading),
     userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
}

//
//      extension ChatListLeftNaviItem {
//        enum Constant {
//          //    enum MenuView {
//          //      static let size = CGSize(width: 26, height: 26)
//          //      static let imageName = "naviMenu"
//          //    }
//          enum userNameLabel {
//            static let spacing: UISpacing = .init(leading: 31)
//            static let fontSize: CGFloat = 32
//          }
//        }
//      }
//
//      final class ChatListLeftNaviItem: UIView {
//        // MARK: - Properties
//
//        var userNameLabel: UILabel!
//
//        // MARK: - Initialization
//        private override init(frame: CGRect) {
//          super.init(frame: frame)
//        }
//
//        required init?(coder: NSCoder) {
//          fatalError("init(coder:) has not been implemented")
//        }
//
//        convenience init(with userName: String) {
//          self.init(frame: .zero)
//          translatesAutoresizingMaskIntoConstraints = false
//          initUserNameLabel()
//          configure(with: userName)
//          setupUI()
//        }
//      }
//
//      // MARK: - Private helpers
//      extension ChatListLeftNaviItem {
//        func configure(with name: String) {
//          let attrString = NSMutableAttributedString(
//            string: "Hello, \(name)님!")
//          let hiAttrStr: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(
//              ofSize: Constant.userNameLabel.fontSize),
//            .foregroundColor: UIColor.Palette.primary]
//
//          let userNameAttrStr: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(
//              ofSize: Constant.userNameLabel.fontSize),
//            .foregroundColor: UIColor.Palette.primary]
//
//          _=[
//            (hiAttrStr,
//             NSRange(location: 0, length: 7)),
//            (userNameAttrStr,
//             NSRange(location: 7, length: name.count+2))]
//            .map { attrString.addAttributes($0, range: $1) }
//
//          userNameLabel?.attributedText = attrString
//        }
//
//        func initUserNameLabel() {
//          userNameLabel = UILabel().set {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            $0.numberOfLines = 2
//            $0.textAlignment = .left
//          }
//        }
//      }
//
//      // MARK: - LayoutSupport
//      extension ChatListLeftNaviItem: LayoutSupport {
//        func addSubviews() {
//          addSubview(userNameLabel)
//        }
//
//        func setConstraints() {
//          NSLayoutConstraint.activate(userNameLabelConstraints)
//        }
//      }
//
//      private extension ChatListLeftNaviItem {
//        var userNameLabelConstraints: [NSLayoutConstraint] {
//          [userNameLabel.leadingAnchor.constraint(
//            equalTo: leadingAnchor,
//            constant: Constant.userNameLabel.spacing.leading),
//           userNameLabel.topAnchor.constraint(
//            equalTo: topAnchor)]
//        }
//      }
