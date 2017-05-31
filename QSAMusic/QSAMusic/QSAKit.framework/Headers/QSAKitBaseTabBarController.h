//
//  QSAKitBaseTabBarController.h
//  QSAKit
//
//  Created by 陈少文 on 17/2/3.
//  Copyright © 2017年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSAKitBaseTabBarController : UITabBarController

#pragma mark - 属性区
#pragma mark tabar
@property (nonatomic) NSArray *titleArray;           //tabar的标题
@property (nonatomic) BOOL    aotuTitle;             //子VC的导航栏标题自动同步为tabBarItem的标题(默认开启), 修改title后发现tabBarItem也改变, 再次设置tabBarItem就行了
@property (nonatomic) NSArray *normalImageArray;     //tabBar的普通图片
@property (nonatomic) NSArray *selectImageArray;     //tabBar的选中图片
@property (nonatomic) UIColor *normalColor;          //tabBar的普通字体颜色
@property (nonatomic) UIColor *selectColor;          //tabBar的选中字体颜色
@property (nonatomic) NSArray *subVCArray;           //tabBar的子VC

#pragma mark navigation
@property (nonatomic) UIBarStyle navigationBarStyle; //tabBar子VC导航栏类型, 可以决定stateBar的字体颜色
@property (nonatomic) UIFont *navigationTitleFont;   //tabBar子VC导航栏的标题font
@property (nonatomic) UIColor *navigationTitleColor; //tabBar子VC导航栏的标题color
@property (nonatomic) UIColor *navigationTintColor;  //tabBar子VC导航栏的按键color
@property (nonatomic) UIImage *navigationBackImage;  //tabBar子VC导航栏的背景图片

#pragma mark - 方法区
/**
 初始化所有子视图
 */
- (void)initSubViewController;

@end
