//
//  Delegete.swift
//  WWTcpConnection
//
//  Created by William.Weng on 2025/1/14.
//

import UIKit
import Network

// MARK: - WWTcpConnectionDelegete
public protocol WWTcpConnectionDelegete: AnyObject {
    
    /// 網路連線狀態
    /// - Parameters:
    ///   - connection: WWTcpConnection
    ///   - state: NWConnection.State
    func connection(_ connection: WWTcpConnection, state: NWConnection.State)
    
    /// 相關錯誤狀態
    /// - Parameters:
    ///   - connection: WWTcpConnection
    ///   - error: WWTcpConnection.ConnectionError?
    func connection(_ connection: WWTcpConnection, error: WWTcpConnection.ConnectionError?)
    
    /// 傳送內容訊息
    /// - Parameters:
    ///   - connection: WWTcpConnection
    ///   - type: 內容訊息 (文字 / 資料)
    ///   - state: NWConnection.State
    func connection(_ connection: WWTcpConnection, sendContent contentType: WWTcpConnection.ContentType, state: NWConnection.State)
    
    /// 接收回傳訊息
    /// - Parameters:
    ///   - connection: WWTcpConnection
    ///   - data: Data
    ///   - state: NWConnection.State
    func connection(_ connection: WWTcpConnection, receiveData data: Data, state: NWConnection.State)
}
