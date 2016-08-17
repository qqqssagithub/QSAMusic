//
//  CSWScreenShot.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 007. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSWScreenShot : NSObject

/**
 *  屏幕截图
 *
 *  @param view 指定view
 *  @param rect 指定rect
 *
 *  @return 以image(png)的方式返回截图
 */
+ (UIImage *)screenShotWithView:(UIView *)view Rect:(CGRect)rect;

/**
 *参数 rect 截图的rect
 */
+ (UIImage *)screenShotWithRect:(CGRect)rect;

@end
