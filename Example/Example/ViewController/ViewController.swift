//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/1/14.
//

import UIKit
import Network
import WWPrint
import WWTcpConnection

// MARK: - ViewController
final class ViewController: UIViewController {

    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myLabel: UILabel!
    
    let connection = WWTcpConnection(host: "127.0.0.1", port: 8080)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connection.create(delegate: self)
    }
    
    @IBAction func send(_ sender: UIBarButtonItem) {
        connection.sendMessage(myTextField.text!)
    }
}

// MARK: - 小工具
extension ViewController: WWTcpConnectionDelegete {
    
    func connection(_ connection: WWTcpConnection, state: NWConnection.State) {
        wwPrint(state)
    }
    
    func connection(_ connection: WWTcpConnection, error: WWTcpConnection.ConnectionError?) {
        wwPrint(error)
    }
    
    func connection(_ connection: WWTcpConnection, sendContent contentType: WWTcpConnection.ContentType, state: NWConnection.State) {
        wwPrint(contentType)
    }
    
    func connection(_ connection: WWTcpConnection, receiveData data: Data, state: NWConnection.State) {   
        DispatchQueue.main.async { self.myLabel.text = String(data: data, encoding: .utf8) }
    }
}
