//
//  BaseViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/23.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//
#import "SDImageCache.h"
#import "AFURLResponseSerialization.h"
#import "NSString+StringExt.h"

#import "TitleCollectionBarCell.h"
#import "BaseViewController.h"
#import "ChannelModel.h"
#import "SingleModel.h"
#import "MJExtension.h"
#import "NSObject+Extension.h"
static UIButton *prevBtn;


@interface BaseViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *channelCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *channelLayout;
@property (nonatomic, strong) NSArray *channelList;
@end

@implementation BaseViewController
#pragma mark - 懒加载模型数组
- (NSArray *)tList {
    if (_tList == nil) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (ChannelModel *channel in self.channelList) {
            NSArray *tListArray = channel.tList;
            for (int i = 0; i < tListArray.count; i++) {
                if ([tListArray[i] isKindOfClass:[SingleModel class]]) {
                    SingleModel *single = tListArray[i];
                    [arrayM addObject:single];
                }
            }
        }
        _tList = arrayM;
    }
    return _tList;
}

- (NSArray *)channelList {
    if (_channelList == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"all.json" withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _channelList = [ChannelModel objectArrayWithJSONData:data];
    }
    return _channelList;
}

#pragma mark － 导航标题collection数据元方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TitleCollectionBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    SingleModel *single = self.tList[indexPath.item];
    cell.model = single;
    cell.tNameBtn.tag = indexPath.item + 100;
    [cell.tNameBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SingleModel *single = self.tList[indexPath.item];
    NSString *tname = single.tname;
    CGSize textSize = [tname sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 35)];
    CGSize collViewSize = CGSizeMake(textSize.width + 14, 30);
    return collViewSize;
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupChannelLayout];

    [self.channelCollection registerClass:[TitleCollectionBarCell class] forCellWithReuseIdentifier:@"CELL"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnWithNoti:) name:@"CollViewPageIndex" object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self btnClickAndAni:(UIButton *)[self.channelCollection viewWithTag:100]];
}

#pragma mark - 按钮状态改变通知方法
- (void)changeBtnWithNoti:(NSNotification *)noti {    NSInteger index = [noti.object integerValue];
    NSLog(@"%ld", (long)index);
    UIButton *btn = (UIButton *)[self.channelCollection viewWithTag:index + 100];
    [self btnClickAndAni:btn];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index + 1 inSection:0];
    if (index < (self.tList.count - 1)) {
        [self.channelCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    [self btnClickAndAni:btn];
#pragma mark = 用通知传btn.tag
    NSNumber *tag = [[NSNumber alloc] initWithInteger:btn.tag - 100];
    NSLog(@"%@", tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseViewBtnTag" object:tag];
}

#pragma mark - 按钮点击动画
- (void)btnClickAndAni:(UIButton *)btn {
    btn.selected = YES;
    if (prevBtn && ![btn isEqual:prevBtn]) {
        prevBtn.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            prevBtn.transform = CGAffineTransformIdentity;
        }];
    }
    prevBtn = btn;
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.4, 1.4);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
        }];
    }];
}

/**
 *  设置ChannelCollectionBar的Layout
 */
- (void)setupChannelLayout {
    self.channelLayout.minimumInteritemSpacing = 0.0;
    self.channelLayout.minimumLineSpacing = 0.0;
    self.channelLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.channelCollection.showsHorizontalScrollIndicator = NO;
    self.channelCollection.showsVerticalScrollIndicator = NO;
}
/**
 *  设置NavigationBar
 */
- (void)setupNavigation {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *headerImage = [UIImage imageNamed:@"home_header_logo"];
    headerImage = [headerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:headerImage];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    titleView.bounds = CGRectMake(0, 0, 40, 25);
    self.navigationItem.titleView = titleView;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"top_navigation_back"]];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *leftImage = [UIImage imageNamed:@"night_top_navigation_menuicon"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"night_top_navigation_menuicon_highlighted"] forState:UIControlStateHighlighted];
    [leftBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)didReceiveMemoryWarning {
    [[SDImageCache alloc] clearMemory];
    NSLog(@"我来了");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CollViewPageIndex" object:nil];
}
@end
