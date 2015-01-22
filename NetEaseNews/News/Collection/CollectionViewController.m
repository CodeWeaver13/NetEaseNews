//
//  CollectionViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
@interface CollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *urlList;
@end

@implementation CollectionViewController
- (NSArray *)urlList {
    if (_urlList == nil) {
        _urlList = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"NewsURLs.plist" withExtension:nil]];
    }
    return _urlList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置布局
    self.layout.itemSize = self.view.bounds.size;
    self.layout.minimumInteritemSpacing = 0.0;
    self.layout.minimumLineSpacing = 0.0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // scrollView的属性
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urlList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsTableCell" forIndexPath:indexPath];
    
    // 设置 URL
    cell.urlString = self.urlList[indexPath.item][@"urlString"];
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)setupNavigation {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *headerImage = [UIImage imageNamed:@"home_header_logo"];
    headerImage = [headerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:headerImage];
    self.navigationItem.titleView = titleView;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"top_navigation_back"]];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *leftImage = [UIImage imageNamed:@"night_top_navigation_menuicon"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"night_top_navigation_menuicon_highlighted"] forState:UIControlStateHighlighted];
    leftBtn.bounds = CGRectMake(-5, 0, 35, 35);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
@end
