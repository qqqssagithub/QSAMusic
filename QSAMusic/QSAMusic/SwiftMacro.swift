//
//  SwiftMacro.swift
//  QSAMusic
//
//  Created by 陈少文 on 17/4/26.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

import UIKit

//常用属性, 模仿OC宏定义
struct SwiftMacro {

    //window尺寸
    let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
    let ScreenWidth:  CGFloat = UIScreen.main.bounds.size.width
    let ScreenRect:   CGRect  = UIScreen.main.bounds
    
    //主屏幕
    let KeyWindow: UIWindow = UIApplication.shared.keyWindow!
    
}
