//
//  CollectionViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//
#define kNaviH 94
#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "BaseViewController.h"
#import "SingleModel.h"
@interface CollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *urlList;
@property (nonatomic, strong) BaseViewController *baseVC;
@end

@implementation CollectionViewController

- (void)changePageWithNoti:(NSNotification *)noti {
    NSLog(@"%@", noti.object);
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[noti.object intValue] inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (NSArray *)urlList {
    if (_urlList == nil) {
        BaseViewController *base = [[BaseViewController alloc] init];
        NSArray *array = base.tList;
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:base.tList.count];
        for (SingleModel *single in array) {
            NSString *str = [NSString stringWithFormat:@"/nc/article/%@/%@/0-20.html", (single.headLine ? @"headline" : @"list"), single.tid];
            [arrayM addObject:str];
        }
        _urlList = arrayM;
    }
    return _urlList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置布局
    self.layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kNaviH);
    self.layout.minimumInteritemSpacing = 0.0;
    self.layout.minimumLineSpacing = 0.0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    // scrollView的属性
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePageWithNoti:) name:@"BaseViewBtnTag" object:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urlList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsTableCell" forIndexPath:indexPath];
    cell.urlString = self.urlList[indexPath.item];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat scrollW = self.collectionView.frame.size.width;
    int page = (self.collectionView.contentOffset.x + 0.5 * scrollW) / scrollW;
    NSNumber *index = [NSNumber numberWithInteger:page];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollViewPageIndex" object:index];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
