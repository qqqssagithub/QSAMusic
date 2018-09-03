//
//  QSAKitPromptView.h 模态提示界面
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSAKitPromptView1 : UIView

@property (nonatomic) CGFloat                    defaultMaxWidth;                   //最大宽度, 默认: 200.0f
@property (nonatomic) UIFont                     *defaultFont;                      //字体, 默认: [UIFont systemFontOfSize:14.0f]
@property (nonatomic) CGFloat                    defaultBackgroundTransparency;     //背景透明度系数, 默认: 0.0f
@property (nonatomic) BlurEffectStyle            defaultBlurEffectStyle;            //模糊风格, 默认: BlurEffectStyleDark
@property (nonatomic) ActivityIndicatorViewStyle defaultActivityIndicatorViewStyle; //转圈图标风格, 默认: ActivityIndicatorViewStyleWhiteLarge

+ (instancetype)sharedInstance;

/**
 默认风格展示(默认提示语: 数据加载中..., 宽度: 224.0, 文字字体大小: 14.0)
 */
+ (void)show;

/**
 带提示语默认风格展示, 不需要提示语时传nil
 
 @param message 提示语
 */
+ (void)showWithMessage:(NSString *)message;

/**
 根据具体参数展示
 
 @param width                      宽(高度会根据内容自适应)
 @param blurEffectStyle            背景风格
 @param activityIndicatorViewStyle 转圈图标风格
 @param message                    提示语
 @param font                       提示语文字font
 @param backgroundTransparency     透明度
 */
+ (void)showWithWidth:(CGFloat)width blurEffectStyle:(BlurEffectStyle)blurEffectStyle activityIndicatorViewStyle:(ActivityIndicatorViewStyle)activityIndicatorViewStyle message:(NSString *)message messageFont:(UIFont *)font backgroundTransparency:(CGFloat)backgroundTransparency;

/**
 消失
 */
+ (void)disappear;

@end
