//
//  QSMusicXinDie.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/7/30.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicXinDie.h"
#import "QSMusicXinDieCollectionViewCell.h"

@interface QSMusicXinDie ()

@property (nonatomic) NSArray *dataArr;
@property (nonatomic) UILabel *bottomLabel;
@property (nonatomic) NSString *bottomLabelStr;
@property (nonatomic) UIColor *bottomLabelColor;
@property (nonatomic) UICollectionReusableView *footer;
@property (nonatomic) UIColor *footerColor;
@property (nonatomic) NSInteger limit;

@end

@implementation QSMusicXinDie

+ (instancetype)sharedQSMusicXinDie {
    static QSMusicXinDie *sharedQSMusicXinDie = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicXinDie = [[QSMusicXinDie alloc] init];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(80, 120);
        flowLayout.sectionInset = UIEdgeInsetsMake( 20, 20, 20, 20);
        sharedQSMusicXinDie.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33) collectionViewLayout:flowLayout];
        [sharedQSMusicXinDie.collectionView registerNib:[UINib nibWithNibName:@"QSMusicXinDieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XinDieCollCellid"];
        sharedQSMusicXinDie.collectionView.backgroundColor = [UIColor whiteColor];
        sharedQSMusicXinDie.collectionView.delegate = sharedQSMusicXinDie;
        sharedQSMusicXinDie.collectionView.dataSource = sharedQSMusicXinDie;
        [sharedQSMusicXinDie.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerid"];
        sharedQSMusicXinDie.limit = 25;
        [sharedQSMusicXinDie requestData];
    });
    return sharedQSMusicXinDie;
}

- (void)requestData {
    [QSMusicPlayer newSingleListWithLimit:_limit responseClosure:^(NSArray * _Nonnull dataArr) {
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
            _dataArr = dataArr;
            [_collectionView reloadData];
        }
    }];
}

#pragma mark - collectionViewDelagate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(QSMUSICSCREEN_WIDTH, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //无提示
    _footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerid" forIndexPath:indexPath];
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, QSMUSICSCREEN_WIDTH - 24, 16)];
    _bottomLabel.textAlignment = 1;
    _bottomLabel.font = QSMusicFont_12;
    _bottomLabel.textColor = _bottomLabelColor;
    for (UILabel *label in _footer.subviews) {
        [label removeFromSuperview];
    }
    _bottomLabel.text = _bottomLabelStr;
    [_footer addSubview:_bottomLabel];
    _footer.backgroundColor = _footerColor;
    //_footer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    return _footer;
//    //有提示
//    _footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerid" forIndexPath:indexPath];
//    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, QSMUSICSCREEN_WIDTH - 24, 16)];
//    _bottomLabel.textAlignment = 1;
//    _bottomLabel.font = QSMusicFont_12;
//    _bottomLabel.textColor = [UIColor lightGrayColor];
//    for (UILabel *label in _footer.subviews) {
//        [label removeFromSuperview];
//    }
//    _bottomLabel.text = _bottomLabelStr;
//    [_footer addSubview:_bottomLabel];
//    _footer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
//    return _footer;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSMusicXinDieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XinDieCollCellid" forIndexPath:indexPath];
    NSDictionary *data = _dataArr[indexPath.row];
    [cell.imagV sd_setImageWithURL:[NSURL URLWithString:data[@"pic_small"]]];
    cell.title.text = data[@"title"];
    cell.name.text = data[@"author"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *album_id = _dataArr[indexPath.row][@"album_id"];
    [self requestSingleWithAlbumId:album_id response:^(NSDictionary *albumInfo, NSArray *songList) {
        [self updateWithAlbumInfo:albumInfo songList:songList];
    }];
}

- (void)requestSingleWithAlbumId:(NSString *)albumId response:(void(^)(NSDictionary *albumInfo, NSArray *songList))completion {
    [CSWProgressView showWithPrompt:@"专辑加载中"];
    [QSMusicPlayer requestSingleWithAlbumId:albumId response:^(NSDictionary * _Nonnull albumInfo, NSArray<NSDictionary *> * _Nonnull songList) {
        NSLog(@"album_id:%@", albumId);
        [CSWProgressView disappear];
        if (completion) {
            completion(albumInfo, songList);
        }
    }];
}

- (void)updateWithAlbumInfo:(NSDictionary *)albumInfo songList:(NSArray *)songList {
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
    [view updateWithHeaderInfo:albumInfo songList:songList];
    [QSMusicRootVC_View addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        rootBackView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        view.frame = QSMUSICSCREEN_RECT;
    }];
}

#pragma mark 上拉加载
//无提示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - (QSMUSICSCREEN_HEIGHT - 64 - 33) - 30) {
        if (![_bottomLabelStr isEqualToString:@""] && ![_bottomLabel.text isEqualToString:@"没有更多了"]) {
            _bottomLabelStr = @"";
            [QSMusicPlayer newSingleListWithLimit:_limit += 25 responseClosure:^(NSArray * _Nonnull dataArr) {
                _bottomLabelStr = @"加载完成";
                if (dataArr.count <= _dataArr.count) {
                    _bottomLabelStr = @"没有更多了";
                    _footerColor = [UIColor colorWithWhite:0.0 alpha:0.1];
                    _bottomLabelColor = [UIColor lightGrayColor];
                }
                _dataArr = dataArr;
                [_collectionView reloadData];
            }];
        }
    }
}

////有提示
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - (QSMUSICSCREEN_HEIGHT - 64 - 33) - 30 && scrollView.contentOffset.y < scrollView.contentSize.height - (QSMUSICSCREEN_HEIGHT - 64 - 33) - 30 + 70) {
//        if (![_bottomLabel.text isEqualToString:@"加载中..."] && ![_bottomLabel.text isEqualToString:@"没有更多了"]) {
//            _bottomLabel.text = @"上拉加载更多";
//        }
//    }
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - (QSMUSICSCREEN_HEIGHT - 64 - 33) - 30 + 20 && ![_bottomLabel.text isEqualToString:@"加载中..."]) {
//        if (![_bottomLabel.text isEqualToString:@"没有更多了"]) {
//            _bottomLabel.text = @"加载中...";
//            _bottomLabelStr = @"加载中...";
//            [QSNewSingleList newSingleListWithLimit:_limit += 25 responseClosure:^(NSArray * _Nonnull dataArr) {
//                _bottomLabel.text = @"加载完成";
//                _bottomLabelStr = @"加载完成";
//                if (dataArr.count <= _dataArr.count) {
//                    _bottomLabel.text = @"没有更多了";
//                    _bottomLabelStr = @"没有更多了";
//                }
//                _dataArr = dataArr;
//                [_collectionView reloadData];
//            }];
//        }
//    }
//}

@end
