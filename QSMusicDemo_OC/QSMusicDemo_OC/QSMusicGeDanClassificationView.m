//
//  QSMusicGeDanClassificationView.m
//  QSMusicDemo_OC
//
//  Created by 陈少文 on 16/8/10.
//  Copyright © 2016年 qqqssa. All rights reserved.
//

#import "QSMusicGeDanClassificationView.h"
#import "QSMusicGeDanTopCollectionViewCell.h"
#import "QSMusicGeDanCVFlowLayout.h"

@interface QSMusicGeDanClassificationView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSArray *dataArr;
@property (nonatomic) NSString *title;

@property (nonatomic) UILabel *bottomLabel;
@property (nonatomic) NSString *bottomLabelStr;
@property (nonatomic) UIColor *bottomLabelColor;
@property (nonatomic) UICollectionReusableView *footer;
@property (nonatomic) UIColor *footerColor;
@property (nonatomic) NSInteger pageSize;

@end

@implementation QSMusicGeDanClassificationView

+ (instancetype)sharedQSMusicGeDanClassificationView {
    static QSMusicGeDanClassificationView *sharedQSMusicGeDanClassificationView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQSMusicGeDanClassificationView = [[QSMusicGeDanClassificationView alloc] init];
        QSMusicGeDanCVFlowLayout *flowLayout = [[QSMusicGeDanCVFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake( 20, 20, 20, 20);
        sharedQSMusicGeDanClassificationView.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33) collectionViewLayout:flowLayout];
        sharedQSMusicGeDanClassificationView.collectionView.backgroundColor = [UIColor whiteColor];
        [sharedQSMusicGeDanClassificationView.collectionView registerNib:[UINib nibWithNibName:@"QSMusicGeDanTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"geDanTopCellid"];
        [sharedQSMusicGeDanClassificationView.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerid"];
        [sharedQSMusicGeDanClassificationView.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerid"];
        sharedQSMusicGeDanClassificationView.collectionView.delegate = sharedQSMusicGeDanClassificationView;
        sharedQSMusicGeDanClassificationView.collectionView.dataSource = sharedQSMusicGeDanClassificationView;
    });
    return sharedQSMusicGeDanClassificationView;
}

- (void)reloadDataWithDataArray:(NSArray *)dataArr title:(NSString *)title {
    _pageSize = 25;
    _dataArr = dataArr;
    _title = title;
    [_collectionView reloadData];
    _collectionView.contentOffset = CGPointMake(0, 0);
}

#pragma mark - collectionViewDelagate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 110);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(QSMUSICSCREEN_WIDTH, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(QSMUSICSCREEN_WIDTH, 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
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
        return _footer;
    }
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerid" forIndexPath:indexPath];
    for (UIView *view in header.subviews) {
        [view removeFromSuperview];
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, QSMUSICSCREEN_WIDTH, 30)];
    [button setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 100, 16)];
    [label setFont:[UIFont systemFontOfSize:12]];
    label.text = _title;
    label.textColor = [UIColor purpleColor];
    [header addSubview:label];
    header.backgroundColor = QSMusicLightBlueColor;
    return header;
}

- (void)back {
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.frame = CGRectMake(QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT, QSMUSICSCREEN_WIDTH, QSMUSICSCREEN_HEIGHT - 64 -33);
    } completion:^(BOOL finished) {
        _bottomLabelStr = @"返回";
        _footerColor = [UIColor clearColor];
        _bottomLabelColor = [UIColor clearColor];
        [_collectionView removeFromSuperview];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QSMusicGeDanTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"geDanTopCellid" forIndexPath:indexPath];
    NSDictionary *data = _dataArr[indexPath.row];
    [cell updateWithData:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [CSWProgressView showWithPrompt:@"歌单加载中"];
    [QSMusicPlayer getSongSheetDetailsWithListid:_dataArr[indexPath.row][@"listid"] responseClosure:^(NSDictionary * _Nonnull data) {
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
}

#pragma mark 上拉加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - (QSMUSICSCREEN_HEIGHT - 64 - 33) - 30) {
        if (![_bottomLabelStr isEqualToString:@""] && ![_bottomLabel.text isEqualToString:@"没有更多了"]) {
            _bottomLabelStr = @"";
            if ([_title isEqualToString:@"精选推荐"]) {
                [QSMusicPlayer getSongSheetWithPageSize:_pageSize += 20 responseClosure:^(NSArray * _Nonnull dataArr) {
                    _bottomLabelStr = @"加载完成";
                    if (dataArr.count <= _dataArr.count) {
                        _bottomLabelStr = @"没有更多了";
                        _footerColor = [UIColor colorWithWhite:0.0 alpha:0.1];
                        _bottomLabelColor = [UIColor lightGrayColor];
                    } else {
                        _dataArr = dataArr;
                    }
                    [_collectionView reloadData];
                }];
            } else {
                [QSMusicPlayer getSongSheetClassDetailsWithPageSize:_pageSize += 20 className:_title responseClosure:^(NSArray * _Nonnull dataArr) {
                    _bottomLabelStr = @"加载完成";
                    if (dataArr.count <= _dataArr.count) {
                        _bottomLabelStr = @"没有更多了";
                        _footerColor = [UIColor colorWithWhite:0.0 alpha:0.1];
                        _bottomLabelColor = [UIColor lightGrayColor];
                    } else {
                        _dataArr = dataArr;
                    }
                    [_collectionView reloadData];
                }];
            }
        }
    }
}

@end
