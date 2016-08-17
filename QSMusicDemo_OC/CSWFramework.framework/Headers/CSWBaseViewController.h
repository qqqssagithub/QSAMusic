//
//  CSWBaseViewController.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWBaseViewController : UIViewController

//设置导航栏左侧按钮(自定义图片或文字和触发方法)
-(void)setLeftButtonWithImage:(UIImage *)image Action:(SEL)action;
-(void)setLeftButtonWithTitle:(NSString*)title Action:(SEL)action;
//配置导航栏左侧按钮文字样式
//-(void)setLeftTitleConfigureWithFont:(UIFont*)textFont TextNormalColor:(UIColor*)normalColor TextSelectColor:(UIColor*)selectColor;

//设置导航栏右侧按钮(自定义图片或文字和触发方法)
-(void)setRightButtonWithImage:(UIImage *)image Action:(SEL)action;
-(void)setRightButtonWithTitle:(NSString*)title Action:(SEL)action;
//配置导航栏右侧按钮文字样式
//-(void)setRightTitleConfigureWithFont:(UIFont*)textFont TextNormalColor:(UIColor*)normalColor TextSelectColor:(UIColor*)selectColor;

@end
