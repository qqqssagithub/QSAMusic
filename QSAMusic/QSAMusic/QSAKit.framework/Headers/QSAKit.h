//
//  QSAKit.h
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for QSAKit.
FOUNDATION_EXPORT double QSAKitVersionNumber;

//! Project version string for QSAKit.
FOUNDATION_EXPORT const unsigned char QSAKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QSAKit/PublicHeader.h>

//BaseViewController
#import <QSAKit/QSAKitBaseViewController.h>   //基础VC
#import <QSAKit/QSAKitBaseTabBarController.h> //基础TabBar

//BaseView
#import <QSAKit/QSAKitBaseView.h>             //基础View

//helpTool
#import <QSAKit/QSAKitScreenShot.h>           //屏幕截图
#import <QSAKit/QSAKitBlurView.h>             //模糊View
#import <QSAKit/UIImage+QSAKitBlur.h>         //图片模糊
#import <QSAKit/UIImage+QSAKitStretching.h>   //UIImage拉伸
#import <QSAKit/NSString+QSAKitSize.h>        //根据字体和最大宽度计算size

//PromptView
#import <QSAKit/QSAKitAlertView.h>            //自定义警示框
#import <QSAKit/QSAKitFlashingPromptView.h>   //自动消失的提示界面
#import <QSAKit/QSAKitPromptView.h>           //模态提示界面
