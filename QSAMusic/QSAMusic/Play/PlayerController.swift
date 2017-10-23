//
//  PlayerController.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/5.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit
import SDWebImage

import AVFoundation

class PlayerController: NSObject, MusicManagerDelegate, QSAAudioPlayerDelegate {
    
    static let shared = PlayerController()
    
    private override init() {
        super.init()
        MusicManager.shared.delegate = self
        QSAAudioPlayer.shared.delegate = self
    }
    
    private var playList = [NSDictionary]() //播放列表
    
    var playIndex: Int = 0                  //当前播放标记
    var isPlaying = false
    var playTime: Int = 0
    var duration: Int = 0           //总时间
    
    private var oneSong: NSMutableDictionary? = nil
    
    var listReady = false
    
    func prepareList() {
        var dataArr = [Dictionary<String, Dictionary<String, String>>]()
        var clist = ArchiveManager.getCollectionList()
        if clist.count == 0 {
            clist = ArchiveManager.getCacheList()
        }
        for song in clist {
            dataArr.append(song)
        }
        if dataArr.count != 0 {
            listReady = true
            var list = [NSDictionary]()
            for item in dataArr {
                for value in item.values {
                    list.append(value as NSDictionary)
                }
            }
            playList = list
            playIndex = 0
            PlayView.shared().updataList(withData: list)
        }
    }
    
    func play(playList: [NSDictionary], index: Int) {
        self.playList = playList
        playIndex = index
        PlayPointView.shared.open(isList: true)
        PlayPointView.shared.openCallClosure = {
            self.play(index: index)
        }
        PlayView.shared().updataList(withData: playList)
    }
    
    // MARK: - MusicManager代理
    //准备播放, 更新播放界面
    func musicPrepare() {
        let music = playList[playIndex]
        if music["versions"] == nil {
            PlayView.shared().songLabel.text = music["title"] as? String
            PlayView.shared().author.text = music["artist"] as? String
        } else {
            if music["versions"] as! String != "" {
                PlayView.shared().songLabel.text = "\(music["title"] as! String)(\(music["versions"] as! String))"
            } else {
                PlayView.shared().songLabel.text = music["title"] as? String
            }
            PlayView.shared().author.text = music["author"] as? String
        }
        PlayView.shared().currentTime.text = "00:00"
        PlayView.shared().audioSlider.value = 0.0
        PlayView.shared().totalTime.text = "00:00"
        PlayView.shared().starImgV.image = UIImage(named: "QSAMusic_pc.png")
        PlayView.shared().playViewBackImageView.image = nil
        PlayView.shared().scImgV.image = UIImage(named: "ax_0.png")
        PlayView.shared().scButton.isEnabled = true
        
        LrcTableView.shared().initLrc(withLrcStr: "")
        LrcTableView.shared().updateLrc(withCurrentTime: "00:00")
    }
    
    //准备完毕
    func music(createComplete music: NSMutableDictionary) {
        if music["version"] as! String != "" {
            PlayView.shared().songLabel.text = "\(music["songName"] as! String)(\(music["version"] as! String))"
        } else {
            PlayView.shared().songLabel.text = music["songName"] as? String
        }
        PlayView.shared().author.text = music["artistName"] as? String
        PlayView.shared().currentTime.text = "00:00"
        PlayView.shared().audioSlider.value = 0.0
        PlayView.shared().totalTime.text = String(format: "%02ld:%02ld", music["time"] as! Int / 60, music["time"] as! Int % 60)
        self.duration = music["time"] as! Int
        if music["like"] as! String == "1" {
            PlayView.shared().scImgV.image = UIImage(named: "ax_1.png")
        }
        PlayView.shared().scButton.isEnabled = true
        oneSong = music
        LrcTableView.shared().initLrc(withLrcURL: music["lrcLink"] as! String)
        
        let sdManager = SDWebImageManager.shared()
        var urlStr = music["songPicBig"] as! String
        if urlStr == "" || urlStr.characters.count < 10 {
            QSMusicRemoteEvent.shared().addLockScreenView(withTitle: "\(music["songName"] as! String)", time: String(format: "%ld", Int(music["time"] as! NSNumber)), author: "\(music["artistName"] as! String)", image: UIImage(named: "QSAMusic_pc.png"))
        } else {
            urlStr = urlStr.replaceToScreenSize(old: "_150", new: "_500")
            let url = URL(string: urlStr)
            _ = sdManager?.downloadImage(with: url, progress: { (receivedSize, expectedSize) in
            }, completed: { (image, errer, _, _, imageURL) in
                PlayView.shared().starImgV.image = image
                PlayView.shared().playViewBackImageView.image = image?.blur(with: UIColor.black)
                QSMusicRemoteEvent.shared().addLockScreenView(withTitle: "\(music["songName"] as! String)", time: String(format: "%ld", Int(music["time"] as! NSNumber)), author: "\(music["artistName"] as! String)", image: image)
            })
        }
    }
    
    func musicDownload(updateProgress progress: Double) {
        DispatchQueue.main.async(execute: {
            PlayView.shared().progressView.progress = Float(progress)
        })
    }
    
    func musicDownloadFail(error: Int) {
//        if error == -1009 && !isPlaying {
//            QSAKitFlashingPromptView.show(withMessage: "音乐加载失败, 请检查网络")
//            QSAAudioPlayer.shared.pause()
//        } else {
//            self.playNextIndex()
//        }
    }
    
    // MARK: - QSAAudioPlayer代理
    func player(updatePlayProgress playProgress: Float) {
        DispatchQueue.main.async(execute: {
            if !PlayView.shared().audioSlider.isTracking {
                PlayView.shared().audioSlider.value = playProgress
            }
        })
    }
    
    func player(updatePlayTime playTime: Int) {
        self.playTime = playTime
        let time = String(format: "%02ld", playTime / 60) + ":" + String(format: "%02ld", playTime % 60)
        DispatchQueue.main.async(execute: {
            PlayView.shared().currentTime.text = time
            LrcTableView.shared().updateLrc(withCurrentTime: time)
        })
    }
    
    func playerPlayEnd() {
        playNextIndex()
    }
    
    // MARK: - play界面操作
    //收藏
    func like() {
        var like = false
        if oneSong?["like"] as! String == "1" {
            oneSong?.setValue("0", forKey: "like")
            PlayView.shared().scImgV.image = UIImage(named: "ax_0.png")
            ArchiveManager.cancelCollection(collectionList: ArchiveManager.getCollectionList(), songId: oneSong?["songId"] as! String)
        } else {
            oneSong?.setValue("1", forKey: "like")
            PlayView.shared().scImgV.image = UIImage(named: "ax_1.png")
            ArchiveManager.setCollectionList(songId: oneSong?["songId"] as! String)
            like = true
        }
        MineViewController.shared.itemChange(like: like, songId: oneSong?["songId"] as! String)
        if ArchiveManager.archiveManagerEncode(songId: oneSong?["songId"] as! String, data: oneSong!) {
            QSALog("收藏状态修改成功")
        } else {
            QSALog("收藏状态修改失败")
        }
    }
    
    //循环模式
    func changeCycleMode() -> String {
        if SystemSettings().cycleMode() == SystemSettings.CycleMode.List {
            SystemSettings().cycleMode(cycleMode: SystemSettings.CycleMode.Single)
            return "单曲循环"
        } else if SystemSettings().cycleMode() == SystemSettings.CycleMode.Single {
            SystemSettings().cycleMode(cycleMode: SystemSettings.CycleMode.Random)
            return "随机播放"
        } else {
            SystemSettings().cycleMode(cycleMode: SystemSettings.CycleMode.List)
            return "列表循环"
        }
    }
    
    func cycleMode() -> String {
        if SystemSettings().cycleMode() == SystemSettings.CycleMode.List {
            return "列表循环"
        } else if SystemSettings().cycleMode() == SystemSettings.CycleMode.Single {
            return "单曲循环"
        } else {
            return "随机播放"
        }
    }
    
    //上一曲
    func playPreviousIndex() {
        if SystemSettings().cycleMode() == SystemSettings.CycleMode.Random {
            let temp = Int(arc4random() % UInt32(playList.count))
            if temp == playIndex {
                playIndex -= 1
            } else {
                playIndex = temp
            }
        } else {
            playIndex -= 1
        }
        if playIndex  == -1 {
            playIndex = playList.count - 1
        }
        self.play(index: playIndex)
    }
    
    //下一曲
    func playNextIndex(isAuto: Bool = true) {
        if SystemSettings().cycleMode() == SystemSettings.CycleMode.Random {
            let temp = Int(arc4random() % UInt32(playList.count))
            if temp == playIndex {
                playIndex += 1
            } else {
                playIndex = temp
            }
        } else if SystemSettings().cycleMode() == SystemSettings.CycleMode.List {
            playIndex += 1
        } else {
            if !isAuto {
                playIndex += 1
            }
        }
        if playIndex == playList.count {
            playIndex = 0
        }
        self.play(index: playIndex)
    }
    
    func play(index: Int) {
        ListTableViewDelegate.shared().selectRow(index)
        isPlaying = true
    }
    
    func playAndPause() {
        if QSAAudioPlayer.shared.playing {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        QSAAudioPlayer.shared.play()
        isPlaying = true
        DispatchQueue.main.async(execute: {
            PlayView.shared().playButtonView.playButton.setImage(UIImage(named: "zantingduan3"), for: UIControlState.normal)
        })
    }
    
    func pause() {
        QSAAudioPlayer.shared.pause()
        isPlaying = false
        DispatchQueue.main.async(execute: {
            PlayView.shared().playButtonView.playButton.setImage(UIImage(named: "bf"), for: UIControlState.normal)
        })
    }
    
    func play(offset: Float) {
        MusicManager.shared.getMusic(playOffset: offset)
    }
    
    func play(time: Int) {
        MusicManager.shared.getMusic(playTime: Float(time))
    }
    
    //耳机拔出
    public func headphonePullOut() {
        pause()
        QSAAudioPlayer.shared.headphonePullOut()
    }
    
}
