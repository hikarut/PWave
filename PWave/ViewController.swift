//
//  ViewController.swift
//  PWave
//
//  Created by HikaruTakahashi on 2017/01/28.
//  Copyright © 2017年 hikaru. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    let mwmDevice = MWMDevice()
    let websocket = WebSocketModel()
    var timer: Timer!
    var deviceId: String = ""
    var mfgId: String = ""
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        mwmDevice.delegate = self
        mwmDevice.enableConsoleLog(true)
        
        websocket.connect()
        
        // タイマー処理
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerAction),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func timerAction() {
        //websocket.send(string: "aaaa")
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
        }
    }
    
    @IBAction func disconnect(_ sender: UIButton) {
        mwmDevice.disconnectDevice()
    }
}

extension ViewController: MWMDelegate {
    
    // protocol
    func deviceFound(_ devName: String!, mfgID: String!, deviceID: String!) {
        print("deviceFound")
        print(devName)
        print(mfgID)
        print(deviceID)
        
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
//        print("eegSample")
    }
    
    func eSense(_ poorSignal: Int32, attention: Int32, meditation: Int32) {
        print("eSense")
        attentionLabel.text = String(attention)
        meditationLabel.text = String(meditation)
    }
    
    func eegPowerDelta(_ delta: Int32, theta: Int32, lowAlpha: Int32, highAlpha: Int32) {
        print("eegPowerDelta")
        deltaLabel.text = String(delta)
        thetaLabel.text = String(theta)
        lowAlphaLabel.text = String(lowAlpha)
        highAlphaLabel.text = String(highAlpha)
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
