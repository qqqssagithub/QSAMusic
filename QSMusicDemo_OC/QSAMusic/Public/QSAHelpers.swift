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
