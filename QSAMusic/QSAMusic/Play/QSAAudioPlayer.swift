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
    var engine = AVAudioEngine()                           //engine
    private var internalAudioFile: AVAudioFile?            //播放文件
    var internalPlayer = AVAudioPlayerNode()               //播放器
//    private var defaultSampleRate: Double = 44100.0        //默认采样率
//    private var defaultChannels: AVAudioChannelCount = 2   //默认通道
    var timer: DispatchSourceTimer?                        //读取播放进度的定时器
    private var eq = AVAudioUnitEQ(numberOfBands: 10)      //均衡器
    private var startTime: Double = 0                      //开始播放的时间
    
    // MARK: - open variables
    open var delegate: QSAAudioPlayerDelegate?
    open var playing = false
    
    // MARK: - sharedInstance
    open static let shared = QSAAudioPlayer()
    
    private override init() {
        super.init()
    }
    
    // MARK: - engine设置
    ///将节点连接到engine上, 并启动engine
    func startEngine() {
        //初始化eq均衡器的frequency数值, 参考qq音乐播放器
        let frequencys = [31.0, 62.0, 125.0, 250.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
        for i in 0...9 {
            let filterParams = eq.bands[i]
            filterParams.bandwidth = 1.0
            filterParams.bypass = false
            filterParams.frequency = Float(frequencys[i])
        }
        
        //let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: defaultSampleRate, channels: defaultChannels)
        connectNode(format: nil)
        if !engine.isRunning {
            do {
                try engine.start()
            } catch let error as NSError {
                QSALog("couldn't start engine, Error: \(error)")
            }
        }
    }
    
    ///连接节点
    private func connectNode(format: AVAudioFormat?) {
        engine.attach(internalPlayer)
        engine.attach(eq)
        engine.connect(internalPlayer, to: eq, format: format)
        engine.connect(eq, to: engine.mainMixerNode, format: format)
    }
    
    
//    //重新连接所有节点
//    private func reconnectNode(format: AVAudioFormat) {
//        engine.stop()
//        engine.disconnectNodeOutput(internalPlayer)
//        engine.connect(internalPlayer, to: engine.mainMixerNode, format: format)
//        do {
//            try engine.start()
//        } catch let error as NSError {
//            QSALog("couldn't start engine, Error: \(error)")
//        }
//    }
    
    
    // MARK: - player操作
    ///播放器暂停后同时要暂停engine, 这样锁屏界面才会暂停, 但此时锁屏界面的时间并没有停止, 再次恢复播放的时候, 时间会直接跳过暂停的时长. 百度音乐盒也有同样的问题, 只是它做了处理, 再次刷新了时间
    public func play() {
        if !playing {
            if !engine.isRunning {
                try? engine.start()
            }
            if engine.isRunning {
                internalPlayer.play()
                playing = true
                timer?.resume()
            }
        }
    }
    
    public func pause() {
        if playing {
            internalPlayer.pause()
            engine.pause()
            playing = false
            timer?.suspend()
        }
    }
    
    //耳机拔出
    public func headphonePullOut() {
        try? engine.start()
    }
    
    //准备
    public func prepare() {
        playing = false
        internalPlayer.stop()
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
            
            ///如果使用如下方法
            ///internalPlayer.scheduleFile(_ file: AVAudioFile, at when: AVAudioTime?, completionHandler: AVFoundation.AVAudioNodeCompletionHandler? = nil)
            ///先判断当前播放文件的采样率和通道是否和engine的设置相同, 如果不同, 重新设置engine.(比如此时engine的采样率为:44000, 而文件的采样率为:48000, 那么播放的速度就是44000 / 48000 < 1, 音乐听上去就是慢放, 反之就是快放. 这是使用第三方库AudioKit的播放器AKAudioPlayer发现的)
//            if internalAudioFile?.fileFormat.sampleRate != defaultSampleRate || internalAudioFile?.fileFormat.channelCount != defaultChannels {
//                let newFormat = AVAudioFormat(standardFormatWithSampleRate: (internalAudioFile?.fileFormat.sampleRate)!, channels: (internalAudioFile?.fileFormat.channelCount)!)
//                reconnectNode(format: newFormat)
//            }
            
            ///为播放器准备文件
            ///此处有个坑, 当audio文件播放完毕后, 如果调用completionHandler播放完成函数, 那么再调用internalPlayer?.stop()就会崩溃, 如果不调用internalPlayer?.stop(), 时间就无法重置. 所以此处不设置播放完成函数, 用其他方法实现播放完成回调
            internalPlayer.scheduleFile(internalAudioFile!, at: nil, completionHandler: nil)
            
            ///定时器读取播放进度
            timer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
            let timer_s = endTime - startTime
            timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(timer_s))
            timer?.setEventHandler {
                let s = self.currentTime()
                if Int(lround(s)) == endTime + 1 {
                    self.internalPlayer.pause()
                    self.delegate?.playerPlayEnd!()
                }
                self.delegate?.player!(updatePlayTime: Int(lround(s)))
                self.delegate?.player!(updatePlayProgress: Float(Float(s) / Float(endTime)))
            }
            
            ///play
            play()
        } else {
            QSALog("音乐文件加载失败")
            QSAKitFlashingPromptView.show(withMessage: "音乐文件加载失败")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                self.delegate?.playerPlayEnd!()
            })
        }
    }
    
    private func currentTime() -> Double {
        if let nodeTime = internalPlayer.lastRenderTime,
            let playerTime = internalPlayer.playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate + startTime
        }
        return 0.0
    }
    
    //MARK: - eq
    public func updateEQ(gains: [String]) {
        for i in 0...9 {
            let filterParams = eq.bands[i]
            filterParams.gain = Float(gains[i])!
        }
    }
    
    public func updateEQ(BandIndex: Int, gain: Float) {
        let filterParams = eq.bands[BandIndex]
        filterParams.gain = gain
    }
}

//MARK: - QSAAudioPlayerDelegate
@objc public protocol QSAAudioPlayerDelegate: NSObjectProtocol {
    
    @objc optional func player(updatePlayTime playTime: Int)
    
    @objc optional func player(updatePlayProgress playProgress: Float)
    
    @objc optional func playerPlayEnd()
}
