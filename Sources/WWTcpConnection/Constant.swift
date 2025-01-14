//
//  Constant.swift
//  WWTcpConnection
//
//  Created by William.Weng on 2025/1/14.
//

import UIKit
import Network

// MARK: - 常數
public extension WWTcpConnection {
    
    /// 連線錯誤
    enum ConnectionError: Error {
        case network(_ error: NWError)      // 網路連線錯誤
        case custom(_ message: String)      // 其它自訂錯誤
    }
    
    /// 傳送資料類型
    enum ContentType {
        case message(_ message: String)     // 純文字
        case data(_ data: Data)             // 資料
    }
}
