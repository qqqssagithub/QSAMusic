//
//  QSAHelpers.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/5/12.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

/*****音乐资源下载错误代码
 //网络中断：-1005
 //无网络连接：-1009
 //请求超时：-1001
 //服务器内部错误：-1004
 //找不到服务器：-1003
 //没有连接地址: 22156
 //归档失败：-1000
 */

open class QSAHelpers: NSObject {
    // Turn off logging
    open static var enableLogging: Bool = true
    
}

public typealias QSACallback = (Void) -> Void

public func QSALog(_ string: String, fName: String = #function, fLine: Int = #line, file: String = #file) {
    if QSAHelpers.enableLogging {
        print("----> file: \(file) \n----> func: \(fName) \n----> line: \(fLine) \n----> info: \(string) \n----------------------")
    }
}

public func getTime(function:()->()){
    let start = CACurrentMediaTime()
    function()
    let end = CACurrentMediaTime()
    QSALog("方法耗时为：\(end - start)")
}

//extension String {
//    // 对象方法
//    func getFileSize() -> UInt64  {
//        var size: UInt64 = 0
//        let fileManager = FileManager.default
//        var isDir: ObjCBool = false
//        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
//        // 判断文件存在
//        if isExists {
//            // 是否为文件夹
//            if isDir.boolValue {
//                // 迭代器 存放文件夹下的所有文件名
//                let enumerator = fileManager.enumerator(atPath: self)
//                for subPath in enumerator! {
//                    // 获得全路径
//                    let fullPath = self.appending("/\(subPath)")
//                    do {
//                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
//                        size += attr[FileAttributeKey.size] as! UInt64
//                    } catch  {
//                        QSALog("error :\(error)")
//                    }
//                }
//            } else {    // 单文件
//                do {
//                    let attr = try fileManager.attributesOfItem(atPath: self)
//                    size += attr[FileAttributeKey.size] as! UInt64
//                } catch  {
//                    QSALog("error :\(error)")
//                }
//            }
//        }
//        return size
//    }
//}

extension String {
    // 获取文件大小
    func getFileSize() -> Int64  {
        var size: Int64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            do {
                let attr = try fileManager.attributesOfItem(atPath: self)
                size += attr[FileAttributeKey.size] as! Int64
            } catch  {
                QSALog("文件size获取失败 :\(error)")
            }
        } else {
            QSALog("音乐文件不存在")
        }
        return size
    }
}

extension String {
    mutating func removeExcess(excess: [String]) -> String {
        for str in excess {
            self = self.replacingOccurrences(of: str, with: "")
        }
        return self
    }
}
