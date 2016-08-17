//
//  UIImage+CSWBlur.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 007. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *图片模糊类
 *使用是要在工程中添加 Accelerate.frameworks 这个库,否则嘿嘿.....
 */

@interface UIImage (CSWBlur)

/**
 参数 tintColor 上层蒙层的颜色
 */
- (UIImage *)blurWithTintColor:(UIColor *)tintColor;

/**
 参数 radius    模糊半径系数
 参数 tintColor 上层蒙层的颜色
 */
- (UIImage *)blurWithRadius:(CGFloat)radius
                  tintColor:(UIColor *)tintColor;

/**
 *使用默认模糊系数且不使用上层蒙层颜色进行模糊
 */
- (UIImage *)blurWithNil;

@end
