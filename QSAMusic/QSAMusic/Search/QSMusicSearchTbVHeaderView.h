//
//  QSMusicSearchTbVHeaderView.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/14.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSMusicSearchTbVHeaderView : UIView

@property (nonatomic, copy) void(^buttonBlock)(NSInteger);

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UITextField *moreTF;

@end
