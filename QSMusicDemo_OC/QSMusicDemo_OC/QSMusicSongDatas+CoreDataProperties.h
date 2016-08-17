//
//  QSMusicSongDatas+CoreDataProperties.h
//  
//
//  Created by 陈少文 on 16/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QSMusicSongDatas.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSMusicSongDatas (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *lrclink;
@property (nullable, nonatomic, retain) NSString *pic_radio;
@property (nullable, nonatomic, retain) NSString *songid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *versions;

@end

NS_ASSUME_NONNULL_END
