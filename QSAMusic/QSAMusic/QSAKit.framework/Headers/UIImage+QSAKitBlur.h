//
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QSAKitBlur)

//  UIImage+QSAKitBlur.h 图片模糊, 使用时要在工程中添加 Accelerate.frameworks,否则vImageBoxConvolve_ARGB8888报错

/**
 图片模糊
 
 @param radius    模糊半径系数
 @param color     上层蒙层的颜色
 @return          模糊后的图片
 */
- (UIImage *)blurWithRadius:(CGFloat)radius color:(UIColor *)color;


/**
 图片模糊(默认模糊半径)

 @param color 上层蒙层的颜色
 @return      模糊后的图片
 */
- (UIImage *)blurWithColor:(UIColor *)color;


/**
 图片模糊(默认模糊半径, 无上层蒙层颜色)

 @return 模糊后的图片
 */
- (UIImage *)blurWithNil;

@end
