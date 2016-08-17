//
//  QSMusicSearchResultView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/12.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicSearchResultView.h"
#import "QSMusicSearchResultViewLeftTbVDelegate.h"
#import "QSMusicSearchResultViewRightTbVDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation QSMusicSearchResultView

- (IBAction)back:(UIButton *)sender {
    if (_backBlock) {
        _backBlock();
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    _leftTextField.backgroundColor = QSMusicLightGray;
}

- (void)reloadDataWithData:(NSDictionary *)dataDic {
    NSDictionary *artist_info = dataDic[@"artist_info"];
    NSDictionary *info = artist_info[@"artist_list"][0];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *URL = [NSURL URLWithString:info[@"avatar_middle"]];
    if ([manager diskImageExistsForURL:URL]) {
        UIImage *image =  [[manager imageCache] imageFromDiskCacheForKey:URL.absoluteString];
        _topImgV.image = [image blurWithRadius:10 tintColor:nil];
    }else{
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:info[@"avatar_middle"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                _topImgV.image = [image blurWithRadius:10 tintColor:nil];
            }
        }];
    }
    
    _name.text = dataDic[@"query"];
    
    NSDictionary *song_info = dataDic[@"song_info"];
    [_leftButton setTitle:[NSString stringWithFormat:@"单曲(%ld)", [(NSNumber *)song_info[@"total"] integerValue]] forState:UIControlStateNormal];
    QSMusicSearchResultViewLeftTbVDelegate *leftDelegate = [QSMusicSearchResultViewLeftTbVDelegate sharedQSMusicSearchResultViewLeftTbVDelegate];
    [leftDelegate tableview:_leftTbV reloadDataWithData:song_info];
    
    NSDictionary *album_info = dataDic[@"album_info"];
    [_rightButton setTitle:[NSString stringWithFormat:@"专辑(%ld)", [(NSNumber *)album_info[@"total"] integerValue]] forState:UIControlStateNormal];
    QSMusicSearchResultViewRightTbVDelegate *rightDelegate = [QSMusicSearchResultViewRightTbVDelegate sharedQSMusicSearchResultViewRightTbVDelegate];
    rightDelegate.supView = self;
    [rightDelegate tableview:_rightTbV reloadDataWithData:album_info];
}

- (IBAction)buttonAction:(UIButton *)btn {
    UIButton *btn0 = [self viewWithTag:btn.tag];
    UIButton *btn1 = [self viewWithTag:-btn.tag];
    
    ((UITextField *)[self viewWithTag:btn.tag * 3]).backgroundColor = QSMusicLightGray;
    [btn0 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    ((UITextField *)[self viewWithTag:-btn.tag * 3]).backgroundColor = [UIColor clearColor];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self bringSubviewToFront:[self viewWithTag:btn.tag * 2]];
}

@end
