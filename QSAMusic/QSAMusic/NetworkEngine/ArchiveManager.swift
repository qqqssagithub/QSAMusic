//
//  ArchiveManager.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

//音乐信息归档
class ArchiveManager: NSObject {

    //归档
    class func archiveManagerEncode(songId: String, data: NSMutableDictionary) -> Bool {
        //音乐资源写入本地本地
        let file = "\(songId).archive"
        let path = NSHomeDirectory() + "/Documents" + "/\(file)"
        return NSKeyedArchiver.archiveRootObject(data, toFile: path)
    }
    
    //解档
    class func archiveManagerDecode(songId: String) -> NSMutableDictionary {
        let file = "\(songId).archive"
        let path = NSHomeDirectory() + "/Documents" + "/\(file)"
        if NSKeyedUnarchiver.unarchiveObject(withFile: path) != nil {
            return NSKeyedUnarchiver.unarchiveObject(withFile: path) as! NSMutableDictionary
        }
        return [:]
    }
    
    //缓存列表
    class func getCacheList() -> [Dictionary<String, Dictionary<String, String>>] {
        let path = NSHomeDirectory() + "/Documents" + "/cacheList.archive"
        if NSKeyedUnarchiver.unarchiveObject(withFile: path) != nil {
            return NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [Dictionary<String, Dictionary<String, String>>]
        } else {
            let cacheList = [Dictionary<String, Dictionary<String, String>>]()
            return cacheList;
        }
    }
    

    class func setCacheList(songId: String, data: NSMutableDictionary) {
        setCacheList(songId: songId, data: getInfo(data: data))
    }
    
    private class func setCacheList(songId: String, data: Dictionary<String, String>) {
        var cacheList = getCacheList()
        cacheList.insert([songId: data], at: 0)
        let maxCacheCount = SystemSettings().maxCacheCount
        while cacheList.count > maxCacheCount {
            //QSALog("缓存文件超出: \(cacheList.count)")
            for key in cacheList[maxCacheCount].keys {
                let manager = FileManager.default
                try? manager.removeItem(atPath: NSHomeDirectory() + "/Documents" + "/\(key).archive")
                try? manager.removeItem(atPath: NSHomeDirectory() + "/Documents" + "/\(key).mp3")
                cacheList.remove(at: maxCacheCount)
            }
        }
        NSKeyedArchiver.archiveRootObject(cacheList, toFile: NSHomeDirectory() + "/Documents" + "/cacheList.archive")
        QSALog("缓存文件count: \(cacheList.count)")
    }
    
    //收藏列表(如果音乐被收藏, 则会从缓存列表中剔除)
    class func getCollectionList() -> [Dictionary<String, Dictionary<String, String>>] {
        let path = NSHomeDirectory() + "/Documents" + "/collectionList.archive"
        if NSKeyedUnarchiver.unarchiveObject(withFile: path) != nil {
            return NSKeyedUnarchiver.unarchiveObject(withFile: path) as! [Dictionary<String, Dictionary<String, String>>]
        } else {
            let collectionList = [Dictionary<String, Dictionary<String, String>>]()
            return collectionList;
        }
    }
    
    class func setCollectionList(songId: String) {
        var cacheList = getCacheList()
        var index = 0
        var isBreak = false
        for song in cacheList {
            if isBreak {
                break;
            }
            for (key, value) in song {
                if songId == key {
                    var collectionList = getCollectionList()
                    collectionList.insert([songId: value], at: 0)
                    NSKeyedArchiver.archiveRootObject(collectionList, toFile: NSHomeDirectory() + "/Documents" + "/collectionList.archive")
                    cacheList.remove(at: index)
                    isBreak = true
                    QSALog("缓存列表: \(cacheList.count) -- 收藏列表: \(collectionList.count)")
                } else {
                    index += 1;
                }
            }
        }
        NSKeyedArchiver.archiveRootObject(cacheList, toFile: NSHomeDirectory() + "/Documents" + "/cacheList.archive")
    }
    
    class func cancelCollection(songId: String) {
        var collectionList = getCollectionList()
        var index = 0
        var isBreak = false
        for song in collectionList {
            if isBreak {
                break;
            }
            for (key, value) in song {
                if songId == key {
                    setCacheList(songId: key, data: value)
                    collectionList.remove(at: index)
                    isBreak = true
                    QSALog("缓存列表: \(getCacheList().count) -- 收藏列表: \(collectionList.count)")
                } else {
                    index += 1;
                }
            }
        }
        NSKeyedArchiver.archiveRootObject(collectionList, toFile: NSHomeDirectory() + "/Documents" + "/collectionList.archive")
    }
    
    private class func getInfo(data: NSMutableDictionary) -> Dictionary<String, String> {
        var dic = Dictionary<String, String>();
        dic["author"] = data["artistName"] as? String
        dic["pic_small"] = data["songPicSmall"] as? String
        dic["title"] = data["songName"] as? String
        dic["versions"] = data["version"] as? String
        dic["artist"] = data["artistName"] as? String
        dic["songid"] = data["songId"] as? String
        return dic
    }
}
