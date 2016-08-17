//
//  CSWProgressView.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWProgressView : UIView

/**
 *默认配置属性
 */
@property (nonatomic) UIColor   *backColor;     //背景颜色
@property (nonatomic) BOOL      isBlur;         //背景是否透明
@property (nonatomic) UIColor   *activityColor; //动画的颜色（系统样式有效）
@property (nonatomic) CGFloat   promptSize;     //文字尺寸大小
@property (nonatomic) UIColor   *promptColor;   //文字颜色

@property (nonatomic) BOOL systemIsBlackColor;        //系统样式是否为黑色（默认白色）

/**
 *共享单列
 */
+ (instancetype)sharedCSWProgressView;

/**
 *show
 */
+ (void)show;

/**
 *系统样式
 */
+ (void)showSystem;

/**
 *show
 *!~参数 prompt 提示内容
 */
+ (void)showWithPrompt:(NSString *)prompt;

/**
 *show
 *!~参数 prompt        提示内容
 *!~参数 promptSize    提示内容文字尺寸大小
 *!~参数 promptColor   提示内容文字颜色
 *!~参数 activityColor 动画的颜色
 *!~参数 backColor     背景颜色
 *!~参数 isBlur        背景是否透明
 */
+ (void)showWithPrompt:(NSString *)prompt promptSize:(CGFloat)promptSize promptColor:(UIColor *)promptColor activityColor:(UIColor *)activityColor backColor:(UIColor *)backColor isBlur:(BOOL)isBlur;

/**
 *消失
 */
+ (void)disappear;

@end
