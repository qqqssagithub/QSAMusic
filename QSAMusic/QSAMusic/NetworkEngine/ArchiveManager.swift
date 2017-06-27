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

    class func archiveManagerEncode(songId: String, data: NSMutableDictionary) -> Bool {
        let file = "\(songId).archive"
        let path = NSHomeDirectory() + "/Documents" + "/\(file)"
        return NSKeyedArchiver.archiveRootObject(data, toFile: path)
    }
    
    class func archiveManagerDecode(songId: String) -> NSMutableDictionary {
        let file = "\(songId).archive"
        let path = NSHomeDirectory() + "/Documents" + "/\(file)"
        if NSKeyedUnarchiver.unarchiveObject(withFile: path) != nil {
            return NSKeyedUnarchiver.unarchiveObject(withFile: path) as! NSMutableDictionary
        }
        return [:]
    }
    
}
