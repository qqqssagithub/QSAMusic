//
//  QSAAudioPlayer.swift
//  EEEEE
//
//  Created by 陈少文 on 17/5/11.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit
import AVFoundation

open class QSAAudioPlayer: NSObject, UITableViewDelegate {
    
    // MARK: - private variables
    private var engine = AVAudioEngine()
    private var internalAudioFile: AVAudioFile?
    private var internalPlayer: AVAudioPlayerNode?
    private var defaultSampleRate: Double = 44100.0
    private var defaultChannels: AVAudioChannelCount = 2
    private var timer: DispatchSourceTimer?
    private var completionHandler: QSACallback?
    private var eq: AVAudioUnitEQ?
    private var startTime: Double = 0
    
    // MARK: - open variables
    open var delegate: QSAAudioPlayerDelegate?
    open var playing = false
    
    // MARK: - sharedInstance
    open static let shared = QSAAudioPlayer()
    
    private override init() {
        super.init()
        let sessionInstance = AVAudioSession.sharedInstance()
        do {
            try sessionInstance.setCategory(AVAudioSessionCategoryPlayback)
            startEngine()
        } catch let error as NSError {
            QSALog("AVAudioSession setCategory 发生错误, Error: \(error)")
        }
    }
    
    // MARK: - engine设置
    private func startEngine() {
        let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: defaultSampleRate, channels: defaultChannels)
        connectNode(format: defaultFormat)
        if !engine.isRunning {
            do {
                try engine.start()
            } catch let error as NSError {
                QSALog("couldn't start engine, Error: \(error)")
            }
        }
    }
    
    private func connectNode(format: AVAudioFormat) {
        eq = AVAudioUnitEQ(numberOfBands: 10)
        let frequencys = [31.0, 62.0, 125.0, 250.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
        for i in 0...9 {
            let filterParams = eq?.bands[i]
            filterParams?.bandwidth = 1.0
            filterParams?.bypass = false
            filterParams?.frequency = Float(frequencys[i])
        }
        
        internalPlayer = AVAudioPlayerNode()
        
        engine.attach(eq!)
        engine.attach(internalPlayer!)
        engine.connect(internalPlayer!, to: eq!, format: format)
        engine.connect(eq!, to: engine.mainMixerNode, format: format)
    }
    
    private func reconnectNode(format: AVAudioFormat) {
        engine.detach(eq!)
        engine.detach(internalPlayer!)
        connectNode(format: format)
    }
    
    // MARK: - player操作
    public func playAndPause() {
        if !playing {
            internalPlayer?.play()
            playing = true
            timer?.resume()
        } else {
            internalPlayer?.pause()
            playing = false
            timer?.suspend()
        }
    }
    
    public func prepare() {
        playing = false
        internalPlayer?.stop()
        timer?.cancel()
    }
    
    public func play(startTime: Int = 0, endTime: Int, path: String) {
        self.startTime = Double(startTime)
        
        do {
            internalAudioFile = try AVAudioFile(forReading: URL(string: path)!)
        } catch let error as NSError {
            QSALog("不能打开文件, Error: \(error)")
        }
        
        if (internalAudioFile?.length)! > 0 {
            if internalAudioFile?.fileFormat.sampleRate != defaultSampleRate || internalAudioFile?.fileFormat.channelCount != defaultChannels {
                reconnectNode(format: (internalAudioFile?.fileFormat)!)
            }
            
            internalPlayer?.scheduleFile(internalAudioFile!, at: nil, completionHandler: nil)
            
            timer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
            let s = endTime - startTime
            QSALog("定时器时间: \(s)")
            timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(s))
            timer?.setEventHandler {
                let s = self.currentTime()
                self.delegate?.player!(updatePlayTime: Int(lround(s)))
                self.delegate?.player!(updatePlayProgress: Float(Float(s) / Float(endTime)))
            }
            
            playAndPause()
        } else {
            QSALog("音乐文件加载失败")
            QSAKitFlashingPromptView.show(withMessage: "音乐文件加载失败")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                self.delegate?.playerPlayEnd!()
            })
        }
    }
    
    private func currentTime() -> Double {
        if let nodeTime = internalPlayer?.lastRenderTime,
            let playerTime = internalPlayer?.playerTime(forNodeTime: nodeTime) {
            if Double(playerTime.sampleTime) > Double((internalAudioFile?.length)!) - Double(playerTime.sampleRate) {
                internalPlayer?.pause()
                delegate?.playerPlayEnd!()
            }
            return Double(playerTime.sampleTime) / playerTime.sampleRate + startTime
        }
        return 0.0
    }
    
    public func updateEQ(gains: [String]) {
        for i in 0...9 {
            let filterParams = eq?.bands[i]
            filterParams?.gain = Float(gains[i])!
        }
    }
    
    public func updateEQ(BandIndex: Int, gain: Float) {
        let filterParams = eq?.bands[BandIndex]
        filterParams?.gain = gain
    }
}

@objc public protocol QSAAudioPlayerDelegate: NSObjectProtocol {
    
    @objc optional func player(updatePlayTime playTime: Int)
    
    @objc optional func player(updatePlayProgress playProgress: Float)
    
    @objc optional func playerPlayEnd()
}
