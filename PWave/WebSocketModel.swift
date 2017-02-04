//
//  WebSocketModel.swift
//  PWave
//
//  Created by HikaruTakahashi on 2017/02/04.
//  Copyright © 2017年 hikaru. All rights reserved.
//

import Starscream

class WebSocketModel {
    
    let socket = WebSocket(url: URL(string: Const.websocketServer)!)
    //let socket = WebSocket(url: URL(string: Const.websocketServerDebug)!)
    
    func connect() {
        socket.delegate = self
        socket.connect()
        print("connect")
    }
    
    func send(string: String) {
        socket.write(string: string)
        print("send")
    }
    
    func disconnect() {
        socket.disconnect()
    }
}

extension WebSocketModel: WebSocketDelegate {
    func websocketDidConnect(socket ws: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("got some data: \(data.count)")
    }
}
