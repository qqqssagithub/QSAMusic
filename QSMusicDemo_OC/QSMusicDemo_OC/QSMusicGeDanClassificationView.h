//
//  QSMusicGeDanClassificationView.h
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/10.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSMusicGeDanClassificationView : NSObject

@property (nonatomic) UICollectionView *collectionView;

+ (instancetype)sharedQSMusicGeDanClassificationView;

- (void)reloadDataWithDataArray:(NSArray *)dataArr title:(NSString *)title;

@end
