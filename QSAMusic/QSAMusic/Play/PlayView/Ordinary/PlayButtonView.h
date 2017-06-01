//
//  PlayButtonView.h
//  MyMusicTest
//
//  Created by qqqssa on 15/12/8.
//  Copyright © 2015年 陈少文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayButtonView : UIView

@property (nonatomic, copy) void(^operation)(UIButton *);//操作

@property (weak, nonatomic) IBOutlet UIButton *cycleButton;    //循环
@property (weak, nonatomic) IBOutlet UIButton *playButton;     //播放
@property (weak, nonatomic) IBOutlet UIButton *nextButton;     //下一曲
@property (weak, nonatomic) IBOutlet UIButton *previousButton; //上一曲
@property (weak, nonatomic) IBOutlet UIButton *otherButton;    //其他

@property (nonatomic) NSInteger               currentLoop;     //循环模式

/**
 *创建播放控制按钮界面单列
 *参数 height 界面的高度
 */
+ (instancetype)sharedPlayButtonViewWithHeight:(CGFloat)height;

@end
