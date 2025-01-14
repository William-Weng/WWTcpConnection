//
//  WWTcpConnection.swift
//  WWTcpConnection
//
//  Created by William.Weng on 2025/1/14.
//

import UIKit
import Network

// MARK: - TCP / IP 連線工具
open class WWTcpConnection: NSObject {
        
    private var host: NWEndpoint.Host = "127.0.0.1"
    private var port: NWEndpoint.Port = 80
    private var queue: DispatchQueue = .global()

    private var connection: NWConnection = NWConnection(host: "127.0.0.1", port: 80, using: .tcp)
    
    private weak var delegate: WWTcpConnectionDelegete?
    
    /// 初始化
    /// - Parameters:
    ///   - host: NWEndpoint.Host
    ///   - port: NWEndpoint.Port
    ///   - queue: DispatchQueue
    public init(host: NWEndpoint.Host, port: NWEndpoint.Port, queue: DispatchQueue = .global()) {
        
        super.init()
        
        self.host = host
        self.port = port
        self.queue = queue
    }
}

// MARK: - 公開函式
public extension WWTcpConnection {
    
    /// 當前連線狀態
    /// - Returns: NWConnection.State
    func state() -> NWConnection.State {
        return connection.state
    }
    
    /// 建立連線
    /// - Parameters:
    ///   - minimumLength: 接收資訊的最小長度
    ///   - maximumLength: 接收資訊的最大長度
    ///   - delegate: WWTcpConnectionDelegete?
    func create(minimumLength: Int = 1, maximumLength: Int = 65535, delegate: WWTcpConnectionDelegete?) {
        
        self.delegate = delegate
                
        connection.cancel()
        connection = NWConnection(host: host, port: port, using: .tcp)
        
        connection.stateUpdateHandler = { [unowned self] state in
            
            switch state {
            case .setup, .preparing, .ready, .cancelled: delegate?.connection(self, state: state)
            case .waiting(let error): delegate?.connection(self, error: .waiting(error))
            case .failed(let error): delegate?.connection(self, error: .failed(error))
            @unknown default: fatalError()
            }
        }
        
        connection.start(queue: queue)
        
        startReceiving(minimumLength: minimumLength, maximumLength: maximumLength)
    }
    
    /// 傳送文字訊息 (APP => TCP)
    /// - Parameters:
    ///   - message: 文字訊息
    ///   - encoding: 文字編號
    func sendMessage(_ message: String, using encoding: String.Encoding = .utf8) {
        
        if let data = message.data(using: encoding) {
            delegate?.connection(self, sendContent: .message(message), state: connection.state)
            sendContent(data); return
        }
        
        delegate?.connection(self, error: .custom("message encoding error."))
    }
    
    /// 傳送資料訊息 (APP => TCP)
    /// - Parameters:
    ///   - data: Data
    func sendData(_ data: Data) {
        delegate?.connection(self, sendContent: .data(data), state: connection.state)
        sendContent(data)
    }
}

// MARK: - 小工具
private extension WWTcpConnection {
    
    /// 開始接收回傳值 (TCP ==> APP)
    /// - Parameters:
    ///   - minimumLength: 接收資訊的最小長度
    ///   - maximumLength: 接收資訊的最大長度
    func startReceiving(minimumLength: Int, maximumLength: Int) {
        
        connection.receive(minimumIncompleteLength: minimumLength, maximumLength: maximumLength) { [unowned self] data, _, isComplete, error in
            
            if let error = error { delegate?.connection(self, error: .network(error)); return }
            if let data = data { delegate?.connection(self, receiveData: data, state: connection.state) }
            
            startReceiving(minimumLength: minimumLength, maximumLength: maximumLength)
        }
    }
    
    /// 傳送二進制訊息 (TCP <== APP)
    /// - Parameter content: Data?
    func sendContent(_ content: Data?) {
        
        connection.send(content: content, completion: .contentProcessed { [unowned self] error in
            guard let error = error else { return }
            delegate?.connection(self, error: .network(error))
        })
    }
}
