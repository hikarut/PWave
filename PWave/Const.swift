//
//  Const.swift
//  PWave
//
//  Created by HikaruTakahashi on 2017/02/04.
//  Copyright © 2017年 hikaru. All rights reserved.
//

struct Const {
    static let interval = 0.5
    
    static let websocketServer = "ws://160.16.241.168:8888/"
    static let websocketServerDebug = "ws://localhost:8080/"
    static let sendInterval = 0.1
    static let sendDataInit: [String: Any] = [
        "a": 0, // attention
        "m": 0, // meditation
    ]
}
