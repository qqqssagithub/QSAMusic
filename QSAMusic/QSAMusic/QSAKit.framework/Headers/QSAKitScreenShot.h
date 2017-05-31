//
//  QSAKitScreenShot.h  屏幕截图
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSAKitScreenShot : NSObject

/**
 屏幕截图
 
 @param view 指定view
 @param rect 指定rect
 @return     以image的方式返回截图
 */
+ (UIImage *)screenShotWithView:(UIView *)view rect:(CGRect)rect;

/**
 屏幕截图
 
 @param rect 指定rect
 @return     以image的方式返回截图
 */
+ (UIImage *)screenShotWithRect:(CGRect)rect;

@end
