//
//  SignUpViewCell+DrawSignUpEndPage.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit
import Lottie

extension SignUpViewCell {
  func drawSignUpEndPage() {
    let lb = UILabel().set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.text = "회원가입을\n축하드립니다!"
      $0.font = .boldSystemFont(ofSize: 24)
      $0.numberOfLines = 2
      $0.textAlignment = .center
    }
    
    let helloAnimView: LottieAnimationView = .init(name: "welcome").set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentMode = .scaleAspectFill
      $0.animationSpeed = 0.8
      $0.loopMode = .loop
    }
    
    let leftAnimView: LottieAnimationView = .init(name: "leftCongratulation").set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.contentMode = .scaleAspectFill
      $0.loopMode = .repeat(2)
    }
    
    _=[lb, helloAnimView, leftAnimView].map { contentView.addSubview($0) }
    
    NSLayoutConstraint.activate([
      lb.centerYAnchor.constraint(
        equalTo: contentView.centerYAnchor,
        constant: 100),
      lb.centerXAnchor.constraint(
        equalTo: contentView.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      helloAnimView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 50),
      helloAnimView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      helloAnimView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
      helloAnimView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 48)])
    
    NSLayoutConstraint.activate([
      leftAnimView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 24),
      leftAnimView.centerYAnchor.constraint(
        equalTo: lb.centerYAnchor,
        constant: 50),
      leftAnimView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.0),
      leftAnimView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.0)])
    
    helloAnimView.play()
    leftAnimView.play()
  }
}
