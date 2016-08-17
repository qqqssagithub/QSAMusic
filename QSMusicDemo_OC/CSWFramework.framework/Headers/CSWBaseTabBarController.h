//
//  CSWBaseTabBarController.h
//  CSWFramework
//
//  Created by 007 on 16/5/23.
//  Copyright © 2016年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWBaseTabBarController : UITabBarController

@property (nonatomic) NSArray *titleArray;//tabar的标题
@property (nonatomic) BOOL aotuTitle;//导航栏标题自动同步为tabBarItem的标题(默认开启)
@property (nonatomic) NSArray *normalImageArray;//tabBar的普通图片
@property (nonatomic) NSArray *selectImageArray;//tabBar的选中图片
@property (nonatomic) NSArray *subVCArray;//tabBar的子VC

//以下为统一设置tabar子VC导航栏的属性
@property (nonatomic) UIFont *navigationTitleFont;//tabBar子VC导航栏的标题font
@property (nonatomic) UIColor *navigationTitleColor;//tabBar子VC导航栏的标题color
@property (nonatomic) UIColor *navigationTintColor;//tabBar子VC导航栏的按键color
@property (nonatomic) UIImage *navigationBackImage;//tabBar子VC导航栏的背景图片

-(void)initSubViewController;//初始化所有视图

@end
