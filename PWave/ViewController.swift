//
//  ViewController.swift
//  PWave
//
//  Created by HikaruTakahashi on 2017/01/28.
//  Copyright © 2017年 hikaru. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class ViewController: UIViewController {
    
    let mwmDevice = MWMDevice()
    let websocket = WebSocketModel()
    var timer: Timer!
    var deviceId: String = ""
    var mfgId: String = ""
    var connectFlag = false
    var sendData = Const.sendDataInit
    
    // 脳波ラベル
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var meditationLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var thetaLabel: UILabel!
    @IBOutlet weak var highAlphaLabel: UILabel!
    @IBOutlet weak var lowAlphaLabel: UILabel!
    @IBOutlet weak var highBetaLabel: UILabel!
    @IBOutlet weak var lowBetaLabel: UILabel!
    @IBOutlet weak var midGammaLabel: UILabel!
    @IBOutlet weak var lowGammaLabel: UILabel!
    @IBOutlet weak var deviceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        mwmDevice.delegate = self
        mwmDevice.enableConsoleLog(true)
        
    }
    
    func send() {
        // ソケット
        websocket.connect()
        
        // タイマー処理
        timer = Timer.scheduledTimer(timeInterval: Const.sendInterval,
                                     target: self,
                                     selector: #selector(self.timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func timerAction() {
        websocket.send(string: String(describing: JSON(sendData)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func scan(_ sender: UIButton) {
        // viewDidLoadでscanしてもタイミング的にうまくいかない
        mwmDevice.scanDevice()
    }
    
    @IBAction func connect(_ sender: UIButton) {
        // デバイスが見つかったらコネクト
        if deviceId != "" {
            mwmDevice.connect(deviceId)
            if !connectFlag {
                send()
            }
            connectFlag = true
        }
    }
    
    @IBAction func disconnect(_ sender: UIButton) {
        // 接続状態だったら切る
        if connectFlag {
            mwmDevice.disconnectDevice()
            // データの初期化
            sendData = Const.sendDataInit
            timer.invalidate()
            deviceLabel.text = ""
            connectFlag = false
        }
    }
}

extension ViewController: MWMDelegate {
    
    // protocol
    func deviceFound(_ devName: String!, mfgID: String!, deviceID: String!) {
        print("deviceFound")
        print(devName)
        print(mfgID)
        print(deviceID)
        
        // デバイス名を表示
        deviceLabel.text = devName
        
        deviceId = deviceID
        mfgId = mfgID
    }
    
    func didConnect() {
        print("didConnect")
    }
    
    func didDisconnect() {
        print("didDisconnect")
        attentionLabel.text = ""
        meditationLabel.text = ""
        deltaLabel.text = ""
        thetaLabel.text = ""
        lowAlphaLabel.text = ""
        highAlphaLabel.text = ""
        lowBetaLabel.text = ""
        highBetaLabel.text = ""
        lowGammaLabel.text = ""
        midGammaLabel.text = ""
    }

    // option
    func eegSample(_ sample: Int32) {
    }
    
    // 集中と瞑想
    func eSense(_ poorSignal: Int32, attention: Int32, meditation: Int32) {
        print("eSense")
        attentionLabel.text = String(attention)
        meditationLabel.text = String(meditation)
        
        // 送信データのセット
        sendData["a"] = attention
        sendData["m"] = meditation
    }
    
    func eegPowerDelta(_ delta: Int32, theta: Int32, lowAlpha: Int32, highAlpha: Int32) {
        print("eegPowerDelta")
        deltaLabel.text = String(delta)
        thetaLabel.text = String(theta)
        lowAlphaLabel.text = String(lowAlpha)
        highAlphaLabel.text = String(highAlpha)
        //1sendData["delta"] = delta
    }
    
    func eegPowerLowBeta(_ lowBeta: Int32, highBeta: Int32, lowGamma: Int32, midGamma: Int32) {
        print("eegPowerLowBeta")
        lowBetaLabel.text = String(lowBeta)
        highBetaLabel.text = String(highBeta)
        lowGammaLabel.text = String(lowGamma)
        midGammaLabel.text = String(midGamma)
    }
    
    func eegBlink(_ blinkValue: Int32) {
        print("eegBlink")
    }
    
    func mwmBaudRate(_ baudRate: Int32, notchFilter: Int32) {
        print("mwmBaudRate")
    }
}
