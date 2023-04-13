//
//  CommunicationWithServer.swift
//  testUDPSocketClient
//
//  Created by 양승현 on 2023/04/14.
//

import UIKit

final class CommunicationController: UIViewController {
  
  // MARK: Properties
  private let photoView: PhotoView = PhotoView()
  private lazy var textField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Type your message here"
    tf.borderStyle = .roundedRect
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.layer.shadowColor = UIColor.gray.cgColor
    tf.layer.shadowOpacity = 0.3
    tf.layer.shadowOffset = CGSize(width: 0, height: 1)
    tf.layer.shadowRadius = 0.6
    tf.delegate = self
    return tf
  }()
  private var service = UDPSocketService.echoServiceInit()
  private lazy var sendButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Send", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .systemPink.withAlphaComponent(0.6)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 10
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOpacity = 0.3
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 5
    button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    return button
  }()
  private var text: String = ""
  
  // MARK: - Lifecycles
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupBackgroundBlur()
    setupSubviews()
  }
  override func viewWillAppear(_ animated: Bool) {
    _=[photoView, textField, sendButton].map{ $0.layer.opacity = 0 }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    drawSubviewsAnimations()
  }
  
}

// MARK: - UITextFieldDelegate
extension CommunicationController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    return true
  }
}

// MARK: - Action methods
extension CommunicationController {
  @objc func sendButtonTapped() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      self.sendButton.backgroundColor = .systemPink.withAlphaComponent(0.2)
    } completion: { _ in
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
        self.sendButton.backgroundColor = .systemPink.withAlphaComponent(0.6)
      }
    }
    let data = text.data(using: .utf8)! as NSData
    let res = service.sendToAnotherUDPSocket(
      from: service.clientSock,
      to: &service.servAddr,
      withData: data)
    
    if res == -1 { print("Error sending data to server")}
  }
}

// MARK: - Helpers
extension CommunicationController {
  private func setupSubviews(){
    _=[photoView,textField,sendButton].map{view.addSubview($0)}
    
    // Set autolayout constraints
    NSLayoutConstraint.activate([
      photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
      photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      photoView.heightAnchor.constraint(equalToConstant: 300),
      
      textField.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 40),
      textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      textField.heightAnchor.constraint(equalToConstant: 40),
      
      sendButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
      sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      sendButton.heightAnchor.constraint(equalToConstant: 40),
      sendButton.widthAnchor.constraint(equalToConstant: 80)
    ])
  }
  private func setupBackgroundBlur() {
    let iv = UIImageView(frame: view.bounds)
    iv.image = UIImage(named: "flower")
    iv.contentMode = .scaleAspectFill
    view.addSubview(iv)
    
    let blur = UIBlurEffect(style: .light)
    let bluredView = UIVisualEffectView(effect: blur)
    bluredView.frame = iv.bounds
    iv.addSubview(bluredView)
    
  }
  private func drawSubviewsAnimations() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0.7,
      options: .curveEaseOut) {
        self.photoView.layer.opacity = 1
      }
    
    UIView.animate(
      withDuration: 0.4,
      delay: 1.1,
      options: .curveEaseOut,
      animations: { [weak self] in
        guard let self = self else { return }
        _=[textField, sendButton].map{$0.layer.opacity = 1}
      }
    )
    
    UIView.animate(withDuration: 1) {
      self.navigationItem.title = "UDP socket study"
    }
    
  }
}

