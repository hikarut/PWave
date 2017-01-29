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
    var deviceId: String = ""
    var mfgId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        mwmDevice.delegate = self
        mwmDevice.enableConsoleLog(true)
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
    }

    // option
    func eegSample(_ sample: Int32) {
//        print("eegSample")
    }
    
    func eSense(_ poorSignal: Int32, attention: Int32, meditation: Int32) {
        print("eSense")
    }
    
    func eegPowerDelta(_ delta: Int32, theta: Int32, lowAlpha: Int32, highAlpha: Int32) {
        print("eegPowerDelta")
        print(delta)
        print(theta)
        print(lowAlpha)
        print(highAlpha)
    }
    
    func eegPowerLowBeta(_ lowBeta: Int32, highBeta: Int32, lowGamma: Int32, midGamma: Int32) {
        print("eegPowerLowBeta")
    }
    
    func eegBlink(_ blinkValue: Int32) {
        print("eegBlink")
    }
    
    func mwmBaudRate(_ baudRate: Int32, notchFilter: Int32) {
        print("mwmBaudRate")
    }
}
