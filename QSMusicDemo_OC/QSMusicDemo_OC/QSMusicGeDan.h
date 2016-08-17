//
//  QSMusicGeDan.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QSMusicGeDanCVFlowLayout.h"

@interface QSMusicGeDan : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) QSMusicGeDanCVFlowLayout *flowLayout;

+ (instancetype)sharedQSMusicGeDan;

@end
