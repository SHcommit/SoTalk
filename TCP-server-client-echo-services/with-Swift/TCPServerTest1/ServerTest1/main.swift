import Foundation

let bufferSize = 1000
let port = 9900

// 소켓 생성
let serverSocket = socket(AF_INET, SOCK_STREAM, 0)
guard serverSocket != -1 else {
  print("Failed to create socket.")
  exit(1)
}

// 소켓 주소 설정
var serverAddress = sockaddr_in()
serverAddress.sin_family = sa_family_t(AF_INET)
serverAddress.sin_port = UInt16(port).bigEndian
serverAddress.sin_addr.s_addr = INADDR_ANY.bigEndian

// 소켓 바인딩
let bindResult = withUnsafePointer(to: &serverAddress) {
  $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
    bind(serverSocket, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
  }
}
guard bindResult != -1 else {
  print("Failed to bind socket.")
  exit(1)
}

// 소켓 리스닝
guard listen(serverSocket, 5) != -1 else {
  print("Failed to listen on socket.")
  exit(1)
}

print("Server is listening on port \(port)")

// 클라이언트 연결 수락
var clientAddress = sockaddr()
var addressLength = socklen_t(MemoryLayout<sockaddr>.size)

let clientSocket = accept(serverSocket, &clientAddress, &addressLength)
if clientSocket == -1 {
  let errorString = String(cString: strerror(errno))
  fatalError("Error accepting connection: \(errorString)")
}

print("Client connected.")

// 데이터 송수신
while true {
  // 클라이언트에서 데이터 수신
  var buffer = [UInt8](repeating: 0, count: bufferSize)
  let bytesRead = recv(clientSocket, &buffer, buffer.count, 0)
  guard bytesRead > 0 else {
    if bytesRead == 0 {
      print("Client disconnected.")
    } else {
      print("Failed to receive data from client.")
    }
    exit(1)
  }
  
  // 수신한 데이터 출력
  let data = NSData(bytes: buffer, length: bytesRead)
  let message = String(data: data as Data, encoding: .utf8)
  print("Received message: \(message ?? "")")
  
  // 클라이언트로 데이터 전송
  let bytesSent = send(clientSocket, buffer, bytesRead, 0)
  guard bytesSent == bytesRead else {
    print("Failed to send data to client.")
    exit(1)
  }
}
