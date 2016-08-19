//
//  QSMusicXinDie.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QSMusicXinDie : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) UICollectionView *collectionView;

+ (instancetype)sharedQSMusicXinDie;

/**
 *  测试模块
 *
 *  @param ts
 */
- (void)down:(void(^)(NSDictionary *re))ts;

@end
