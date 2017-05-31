//
//  QSAKitFlashingPromptView.h 自动消失的提示界面
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSAKitPromptView.h"

@interface QSAKitFlashingPromptView : UIView

@property (nonatomic) CGFloat         defaultMaxWidth;                //最大宽度, 默认: 250.0f
@property (nonatomic) CGFloat         defaultMinWidth;                //最小宽度, 默认: 60.0f
@property (nonatomic) UIFont          *defaultFont;                   //字体, 默认: [UIFont systemFontOfSize:14.0f]
@property (nonatomic) CGFloat         defaultSecond;                  //消失时间, 默认: 2.0f
@property (nonatomic) CGFloat         defaultBackgroundTransparency;  //背景透明度系数, 默认: 0.0f
@property (nonatomic) BlurEffectStyle defaultBlurEffectStyle;         //模糊风格, 默认: BlurEffectStyleDark

+ (instancetype)sharedInstance;

/**
 自动消失的提示界面(默认设置)
 
 @param message 提示语
 */
+ (void)showWithMessage:(NSString *)message;

@end
