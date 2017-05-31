//
//  QSAKitBlurView.h
//  QSAKit
//
//  Created by 陈少文 on 17/5/2.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *背景模糊, 可在上面添加其他View
 */

typedef enum : NSUInteger {
    Blur_whiteColor = 0,
    Blur_blackColor,
} QSAKitBlurViewType;

@interface QSAKitBlurView : UIView

- (instancetype)initWithFrame:(CGRect)rect type:(QSAKitBlurViewType)color;

/**
 *  添加上层视图
 *
 *  @param view 被添加效果的视图
 */
- (void)contentViewAddSubview:(UIView *)view;

@end
