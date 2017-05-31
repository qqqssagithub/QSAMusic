//
//  UIImage+QSAKitStretching.h UIImage拉伸
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QSAKitStretching)

/**
 取图片中心点的1个像素进行拉伸
 
 @param imageName 图片名称
 @return          拉伸后的图片
 */
+ (UIImage *)resizableImage:(NSString *)imageName;

@end
