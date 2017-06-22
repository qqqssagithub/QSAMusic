//
//  MusicManager.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

open class MusicManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    open static let shared = MusicManager()
    
    private override init() {
        super.init()
    }
    
    open var delegate: MusicManagerDelegate?
    
    private var fileHandle_download = FileHandle()
    private var fileHandle_read = FileHandle()
    private var fileHandle_write = FileHandle()
    
    private var musicPath: String = ""
    private var totalContentLength: Int64 = 0
    private var totalReceivedContentLength: Int64 = 0
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
    private var songId: String = ""
    private var oneSong = NSMutableDictionary()
    private var offset: Int64 = 0
    
    private var playOffset: Float = 0.0
    private var playLenght: Int64 = 0
    private var waiting: Bool = false
    
    
    ///指定时间
    public func getMusic(playTime: Float) {
        getMusic(playOffset: playTime / Float(oneSong["time"] as! NSNumber))
    }
    
    //指定偏移进度
    public func getMusic(playOffset: Float) {
        waiting = false
        
        if playOffset == 0 {
            QSAAudioPlayer.shared.prepare()
            QSAAudioPlayer.shared.play(endTime: Int(oneSong["time"] as! NSNumber), path: musicPath)
            return
        }
        
        if playOffset == 1 {
            PlayerController.shared.playNextIndex()
            return
        }
        
        self.playOffset = playOffset
        let size = Float(oneSong["size"] as! NSNumber)
        playLenght = Int64(size * playOffset)
        
        QSAAudioPlayer.shared.prepare()
        
        if playLenght - 104857 > musicPath.getFileSize() {
            waiting = true
            return
        }
        
        fileHandle_read = FileHandle(forReadingAtPath: musicPath)!
        let path = NSHomeDirectory() + "/Documents" + "/" + "play" + "." + "\(oneSong["format"] as! String)"
        
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        if isExists {
            try! fileManager.removeItem(atPath: path)
        }
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        fileHandle_write = FileHandle(forWritingAtPath: path)!

        while playLenght != musicPath.getFileSize() {
            fileHandle_read.seek(toFileOffset: UInt64(playLenght))
            let data = fileHandle_read.readData(ofLength: 104857)
            fileHandle_write.seekToEndOfFile()
            fileHandle_write.write(data)
            playLenght += data.count
        }
        
        QSAAudioPlayer.shared.play(startTime: Int(Float(oneSong["time"] as! NSNumber) * playOffset), endTime: Int(oneSong["time"] as! NSNumber), path: path)
    }
    
    ///下载音乐
    public func getMusic(songId: String) {
        waiting = false
        dataTask?.cancel()
        self.songId = songId
        QSALog("songId: \(songId)")
        let song = ArchiveManager.archiveManagerDecode(songId: songId)
        if song.count != 0 {
            oneSong = song
            musicPath = NSHomeDirectory() + "/Documents" + "/" + songId + "." + "\(song["format"] as! String)"
            delegate?.music!(createComplete: oneSong)
            //isAdequateResources = true
            if song["finish"] as! String != "1" {
                QSALog("断点续传歌曲")
                offset = musicPath.getFileSize()
                delegate?.musicDownload!(updateProgress: Double(offset) / Double(song["size"] as! NSNumber))
                if offset > 104857 {
                    QSAAudioPlayer.shared.play(endTime: Int(song["time"] as! NSNumber), path: musicPath)
                } else {
                    isAdequateResources = false
                }
                self.resumeMusicDownload(song: song, offset: offset)
            } else {
                QSALog("完整歌曲")
                delegate?.musicDownload!(updateProgress: 1.0)
                QSAAudioPlayer.shared.play(endTime: Int(song["time"] as! NSNumber), path: musicPath)
            }
        } else { //新的音乐
            QSALog("新歌曲")
            delegate?.musicPrepare!()
            delegate?.musicDownload!(updateProgress: 0.0)
            NetworkEngine.getSong(songId: songId, responseClosure: { (songDetails) in
                if songDetails.count == 1 {
                   self.delegate?.musicDownloadFail!(error: -1009)
                } else {
                    QSALog("新歌曲信息获取成功")
                    self.oneSong.setValue(songDetails["queryId"], forKey: "songId")
                    self.oneSong.setValue(songDetails["songName"], forKey: "songName")
                    self.oneSong.setValue(songDetails["artistName"], forKey: "artistName")
                    self.oneSong.setValue(songDetails["albumName"], forKey: "albumName")
                    self.oneSong.setValue(songDetails["songPicSmall"], forKey: "songPicSmall")
                    self.oneSong.setValue(songDetails["songPicBig"], forKey: "songPicBig")
                    self.oneSong.setValue(songDetails["lrcLink"], forKey: "lrcLink")
                    self.oneSong.setValue(songDetails["version"], forKey: "version")
                    self.oneSong.setValue(songDetails["time"], forKey: "time")
                    self.oneSong.setValue(songDetails["songLink"], forKey: "songLink")
                    self.oneSong.setValue(songDetails["format"], forKey: "format")
                    self.oneSong.setValue("0", forKey: "finish")
                    self.oneSong.setValue(songDetails["size"], forKey: "size")
                    self.oneSong.setValue("0", forKey: "like")
                    
                    self.offset = 0
                    self.isAdequateResources = false
                    
                    if (self.oneSong["songLink"] as! String) != "" {
                        self.resumeMusicDownload(song: self.oneSong, offset: self.offset)
                    } else {
                        QSAKitFlashingPromptView.show(withMessage: "此歌曲暂不支持试听")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                            self.delegate?.musicDownloadFail!(error: 22156)
                        })
                    }
                }
            })
        }
    }
    
    private var dataTask: URLSessionDataTask?
    private var isAdequateResources: Bool?
    
    //开始下载
    private func resumeMusicDownload(song: NSMutableDictionary, offset: Int64) {
        QSALog("创建歌曲下载dataTask")
        let url = URL(string: song["songLink"] as! String)!
        totalContentLength = Int64(song["size"] as! NSNumber)
        totalReceivedContentLength = offset
        var request = URLRequest(url: url)
        let requestRange = "bytes=\(offset)-\(totalContentLength)"
        request.addValue(requestRange, forHTTPHeaderField: "Range")
        dataTask = session.dataTask(with: request)
        dataTask?.resume()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if offset == 0 {
            if ArchiveManager.archiveManagerEncode(songId: songId, data: oneSong) {
                QSALog("歌曲信息归档成功")
                self.musicPath = NSHomeDirectory() + "/Documents" + "/" + self.songId + "." + "\(oneSong["format"] as! String)"
                FileManager.default.createFile(atPath: self.musicPath, contents: nil, attributes: nil)
                fileHandle_download = FileHandle(forWritingAtPath: musicPath)!
                delegate?.music!(createComplete: oneSong)
            } else {
                QSALog("歌曲信息归档失败")
                delegate?.musicDownloadFail!(error: -1000)
                dataTask.cancel()
            }
        } else {
            QSALog("断点续传歌曲文件打开")
            fileHandle_download = FileHandle(forWritingAtPath: musicPath)!
        }
        
        if response.expectedContentLength != -1 {
            completionHandler(URLSession.ResponseDisposition.allow)
        } else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        fileHandle_download.seekToEndOfFile()
        fileHandle_download.write(data)
        totalReceivedContentLength += data.count
        delegate?.musicDownload!(updateProgress: Double(totalReceivedContentLength) / Double(totalContentLength))
        if (offset <= 104857 && totalReceivedContentLength > 104857 /*0.1mb开始播放*/ && !isAdequateResources!) {
            QSALog("新歌曲可以播放")
            isAdequateResources = true
            QSAAudioPlayer.shared.play(endTime: Int(oneSong["time"] as! NSNumber), path: musicPath)
        }
        if (playLenght - 104857 < totalReceivedContentLength && waiting) {
            waiting = false
            getMusic(playOffset: playOffset)
        }
    }
    
    var tempTotalReceivedContentLength: Int64 = 0
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            let song = ArchiveManager.archiveManagerDecode(songId: songId)
            song.setValue("1", forKey: "finish")
            if ArchiveManager.archiveManagerEncode(songId: songId, data: song) {
                QSALog("下载和归档完成, \(musicPath.getFileSize())")
            }
        } else {
            delegate?.musicDownloadFail!(error: (error as! NSError).code)
        }
    }
}

@objc public protocol MusicManagerDelegate: NSObjectProtocol {
    //准备
    @objc optional func musicPrepare()
    //准备完毕
    @objc optional func music(createComplete music: NSMutableDictionary)
    //下载进度
    @objc optional func musicDownload(updateProgress progress: Double)
    //下载出错
    @objc optional func musicDownloadFail(error: Int)
}

//@objc public protocol MusicManagerDataSource: NSObjectProtocol {
//    
//    
//
//}

