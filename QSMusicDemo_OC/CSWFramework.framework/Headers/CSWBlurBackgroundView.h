//
//  CSWBlurBackgroundView.h
//  CSWFramework
//
//  Created by 陈少文 on 16/8/15.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    whiteColor = 0,
    blackColor,
} CSWBlurBackgroundViewBackgroundColor;

@interface CSWBlurBackgroundView : UIView

- (instancetype)initWithFrame:(CGRect)rect color:(CSWBlurBackgroundViewBackgroundColor)color;

/**
 *  添加上层视图
 *
 *  @param view 被添加效果的视图
 */
- (void)addEffectView:(UIView *)view;

@end
