//
//  QSMusicGeDan.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicGeDan.h"
#import "QSMusicGeDanTopCollectionViewCell.h"
#import "QSMusicGeDanOtherCollectionViewCell.h"
#import "QSMusicGeDanClassificationView.h"

@interface QSMusicGeDan ()

@property (nonatomic) NSArray *cassDataArr;
@property (nonatomic) NSArray *topDataArr;

@property (nonatomic) UICollectionView *subCollectionView;

@end

@implementation QSMusicGeDan

+ (instancetype)sharedQSMusicGeDan {
    static QSMusicGeDan *sharedQSMusicGeDan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicGeDan = [[QSMusicGeDan alloc] init];
        sharedQSMusicGeDan.flowLayout = [[QSMusicGeDanCVFlowLayout alloc] init];
        sharedQSMusicGeDan.flowLayout.sectionInset = UIEdgeInsetsMake( 20, 20, 20, 20);
        sharedQSMusicGeDan.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33) collectionViewLayout:sharedQSMusicGeDan.flowLayout];
        sharedQSMusicGeDan.collectionView.showsVerticalScrollIndicator = NO;
        [sharedQSMusicGeDan.collectionView registerNib:[UINib nibWithNibName:@"QSMusicGeDanTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"geDanTopCellid"];
        [sharedQSMusicGeDan.collectionView registerNib:[UINib nibWithNibName:@"QSMusicGeDanOtherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"geDanOtherCellid"];
        sharedQSMusicGeDan.collectionView.backgroundColor = [UIColor whiteColor];
        sharedQSMusicGeDan.collectionView.delegate = sharedQSMusicGeDan;
        sharedQSMusicGeDan.collectionView.dataSource = sharedQSMusicGeDan;
        [sharedQSMusicGeDan.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerid"];
        [sharedQSMusicGeDan requestData];
    });
    return sharedQSMusicGeDan;
}

- (void)requestData {
    //获取分组
    [QSMusicPlayer getSongSheetClass:^(NSArray * _Nonnull dataArr) {
        _cassDataArr = dataArr;
        [_collectionView reloadData];
    }];
    //第一组数据
    [QSMusicPlayer getSongSheetWithPageSize:8 responseClosure:^(NSArray * _Nonnull dataArr) {
        if (dataArr.count == 0) {
            [CSWAlertView initWithTitle:@"提示" message:@"刷新失败，请检查网络" cancelButtonTitle:@"确定"];
            UINib *nib = [UINib nibWithNibName:@"QSMusicNetFailedView" bundle:nil];
            QSMusicNetFailedView *view = [nib instantiateWithOwner:nil options:nil][0];
            view.frame = CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33);
            [_collectionView addSubview:view];
            view.reload = ^{
                [self requestData];
            };
        } else {
            _topDataArr = dataArr;
            [_collectionView reloadData];
        }
    }];
}

#pragma mark - collectionViewDelagate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _cassDataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _topDataArr.count + 1;
    } else {
        return ((NSArray *)(_cassDataArr[section][@"tags"])).count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(80, 110);
    } else {
        return CGSizeMake(80, 30);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(QSMUSICSCREEN_WIDTH, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerid" forIndexPath:indexPath];
    for (UIView *view in header.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 100, 16)];
    [label setFont:[UIFont systemFontOfSize:12]];
    if (indexPath.section < _cassDataArr.count) {
        label.text = _cassDataArr[indexPath.section][@"title"];
    }
    label.textColor = [UIColor lightGrayColor];
    [header addSubview:label];
    header.backgroundColor = QSMusicLightGray;
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QSMusicGeDanTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"geDanTopCellid" forIndexPath:indexPath];
        if (indexPath.row < _topDataArr.count) {
            NSDictionary *data = _topDataArr[indexPath.row];
            [cell updateWithData:data];
        } else {
            NSDictionary *data = @{@"pic_300":@"", @"listenum":@"-------------", @"title":@"点击查看更多"};
            [cell updateWithData:data];
        }
        return cell;
    } else {
        QSMusicGeDanOtherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"geDanOtherCellid" forIndexPath:indexPath];
        NSArray *arr = (NSArray *)(_cassDataArr[indexPath.section][@"tags"]);
        NSDictionary *data = arr[indexPath.row];
        cell.title.text = data[@"tag"];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row <= 7) {
        [CSWProgressView showWithPrompt:@"歌单加载中"];
        [QSMusicPlayer getSongSheetDetailsWithListid:_topDataArr[indexPath.row][@"listid"] responseClosure:^(NSDictionary * _Nonnull data) {
            [CSWProgressView disappear];
            QSMusicPublicBigHeaderView *view = [QSMusicPublicBigHeaderView sharedQSMusicPublicBigHeaderView];
            __block typeof(view) blockView = view;
            UIView *rootBackView = QSMusicRootVC_rootBackView;
            view.bcakBlock = ^{
                [UIView animateWithDuration:0.3 animations:^{
                    rootBackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    blockView.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT);
                } completion:^(BOOL finished) {
                    [blockView.bottomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    [blockView removeFromSuperview];
                }];
            };
            [view updateWithData:data];
            [QSMusicRootVC_View addSubview:view];
            [UIView animateWithDuration:0.3 animations:^{
                rootBackView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                view.frame = QSMUSICSCREEN_RECT;
            }];
        }];
    } else if (indexPath.section == 0 && indexPath.row == 8) {
        [CSWProgressView showWithPrompt:@"加载中"];
        [QSMusicPlayer getSongSheetWithPageSize:19 responseClosure:^(NSArray * _Nonnull dataArr) {
            [CSWProgressView disappear];
            [self addSubViewWithTitle:@"精选推荐" data:dataArr];
        }];
    } else {
        NSArray *arr = (NSArray *)(_cassDataArr[indexPath.section][@"tags"]);
        NSDictionary *data = arr[indexPath.row];
        [CSWProgressView showWithPrompt:@"加载中"];
        [QSMusicPlayer getSongSheetClassDetailsWithPageSize:19 className:data[@"tag"] responseClosure:^(NSArray * _Nonnull dataArr) {
            [CSWProgressView disappear];
            [self addSubViewWithTitle:data[@"tag"] data:dataArr];
        }];
    }
}

- (void)addSubViewWithTitle:(NSString *)title data:(NSArray *)dataArr{
    QSMusicRootViewController *rootViewController = QSMusicRootVC;
    _subCollectionView = [QSMusicGeDanClassificationView sharedQSMusicGeDanClassificationView].collectionView;
    [rootViewController.bottomScrollView addSubview:_subCollectionView];
    [[QSMusicGeDanClassificationView sharedQSMusicGeDanClassificationView] reloadDataWithDataArray:dataArr title:title];
    [UIView animateWithDuration:0.3 animations:^{
        _subCollectionView.frame = CGRectMake(QSMUSICSCREEN_WIDTH, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33);
    }];
}

@end
