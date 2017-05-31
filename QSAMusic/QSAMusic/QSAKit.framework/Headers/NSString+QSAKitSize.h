//
//  NSString+QSAKitSize.h 根据字体和最大宽度计算size
//  QSAKit
//
//  Created by 陈少文 on 17/2/4.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QSAKitSize)


/**
 计算文字size

 @param font     文字font
 @param maxWidth 最大宽度
 @return         计算后的size
 */
- (CGSize)calculatedSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

@end
