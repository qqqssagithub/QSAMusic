//
//  CSWFlashingAlertView.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWFlashingAlertView : UIView

/**
 *默认配置属性(背景白色,文字黑色,文字大小14.0,带毛玻璃透明效果,2秒消失)
 */
@property (nonatomic) UIColor   *backColor; //背景颜色
@property (nonatomic) BOOL      isBlur;     //背景是否透明
@property (nonatomic) UIColor   *textColor; //文字颜色
@property (nonatomic) CGFloat   textSize;   //文字尺寸大小
@property (nonatomic) NSInteger lostTime;   //停留时间

/**
 *共享单列
 */
+ (instancetype)sharedCSWFlashingAlertView;

/**
 *采用默认设置
 *!~参数 message 提示内容
 */
+ (void)initWithMessage:(NSString *)message;

/**
 *自定制提示框,参数传nil,将采用默认配置
 *!~参数 message   提示内容
 *!~参数 backColor 背景颜色
 *!~参数 textColor 文字颜色
 *!~参数 textSize  文字尺寸大小
 *!~参数 lostTime  停留消失时间
 *!~参数 isBlur    背景是否透明
 */
+ (void)initWithMessage:(NSString *)message backColor:(UIColor *)bacColor textColor:(UIColor *)textColor textSize:(CGFloat)textSize lostTime:(NSInteger)lostTime isBlur:(BOOL)isBlur;

@end
