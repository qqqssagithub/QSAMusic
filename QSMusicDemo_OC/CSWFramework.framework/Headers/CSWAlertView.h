//
//  CSWAlertView.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OtherBlock)();
typedef void (^CancelBlock)();

@interface CSWAlertView : UIView

/**
 *默认配置属性
 */
@property (nonatomic) UIColor           *backColor;           //背景颜色
@property (nonatomic) BOOL              isBlur;               //背景是否透明
@property (nonatomic) UILabel           *title;               //提示标题
@property (nonatomic) UILabel           *message;             //提示详情
@property (nonatomic) UIButton          *cancelButton;        //取消按钮
@property (nonatomic) UIButton          *otherButton;         //其他按钮
@property (nonatomic, copy) OtherBlock  otherBlock;           //其他按钮block回调
@property (nonatomic, copy) CancelBlock cancelBlock;          //取消按钮block回调

/**
 *共享单列
 */
+ (instancetype)sharedCSWAlertView;

/**
 *!~自定制提示框,参数传nil,将采用默认配置
 *!~参数 backColor         背景颜色
 *!~参数 title             提示标题
 *!~参数 message           提示详情
 *!~参数 cancelButtonTitle 取消按钮文字,如果只需要一个按钮时,请传入取消按钮
 *!~参数 otherButtonTitle  其他按钮文字,如果只需要一个按钮时,请传入取消按钮
 *!~参数 isBlur            背景是否透明
 */
+ (instancetype)initWithBackColor:(UIColor *)backColor title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle isBlur:(BOOL)isBlur;

/**
 *自定制提示框,参数传nil,将采用默认配置
 *!~参数 title             提示标题
 *!~参数 message           提示详情
 *!~参数 cancelButtonTitle 取消按钮文字,如果只需要一个按钮时,请传入取消按钮
 *!~参数 otherButtonTitle  其他按钮文字,如果只需要一个按钮时,请传入取消按钮
 */
+ (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

/**
 *!~采用默认设置
 *!~参数 title             提示标题
 *!~参数 message           提示详情
 *!~参数 cancelButtonTitle 取消按钮文字
 */
+ (void)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
