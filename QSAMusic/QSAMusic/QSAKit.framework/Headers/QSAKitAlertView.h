//
//  QSAKitAlertView.h 自定义警示框
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSAKitPromptView.h"

@interface QSAKitAlertView : UIView

@property (nonatomic) void (^cancelBlock)(void);
@property (nonatomic) void (^otherBlock)(void);

@property (nonatomic) CGFloat         defaultWidth;                  //宽, 默认: 250.0f
@property (nonatomic) UIFont          *defaultTitleFont;             //提示标题字体, 默认: [UIFont fontWithName:@"Helvetica-Bold" size:14.0f]
@property (nonatomic) UIFont          *defaultMessageFont;           //提示语字体, 默认: [UIFont systemFontOfSize:12.0f]
@property (nonatomic) CGFloat         defaultBackgroundTransparency; //背景透明度系数, 默认: 0.3f
@property (nonatomic) BlurEffectStyle defaultBlurEffectStyle;        //模糊风格, 默认: BlurEffectStyleLight

@property (nonatomic) UIButton        *cancelButton;                 //取消按钮
@property (nonatomic) UIButton        *otherButton;                  //其他按钮

+ (instancetype)sharedInstance;

/**
 显示提示框

 @param title             提示标题
 @param message           提示信息
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitle  其他按钮
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;


/**
 显示带额外view的提示框

 @param title             提示标题
 @param message           提示信息
 @param additionalView    额外view
 @param cancelButtonTitle 取消按钮
 @param otherButtonTitle  其他按钮
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message additionalView:(UIView *)additionalView cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

@end
