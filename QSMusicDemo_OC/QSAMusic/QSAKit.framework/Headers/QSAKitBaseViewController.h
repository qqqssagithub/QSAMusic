//
//  QSAKitBaseViewController.h
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSAKitBaseViewController : UIViewController

#pragma mark - 设置导航栏左侧按钮
/**
 自定义图片

 @param image  按钮图片
 @param action 回调方法
 */
- (void)setLeftButtonWithImage:(UIImage *)image Action:(SEL)action;

/**
 自定义文字
 
 @param title  按钮文字
 @param action 回调方法
 */
- (void)setLeftButtonWithTitle:(NSString*)title Action:(SEL)action;


#pragma mark - 设置导航栏右侧按钮
/**
 自定义图片
 
 @param image  按钮图片
 @param action 回调方法
 */
- (void)setRightButtonWithImage:(UIImage *)image Action:(SEL)action;

/**
 自定义文字
 
 @param title  按钮文字
 @param action 回调方法
 */
- (void)setRightButtonWithTitle:(NSString*)title Action:(SEL)action;


@end
