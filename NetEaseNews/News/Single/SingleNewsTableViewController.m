//
//  SingleNewsTableViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "SingleNewsTableViewController.h"
#import "SingleModel.h"
#import "SingleNewsCell.h"
#import "SingleNewsHeaderCell.h"
#import "DetailNavigationController.h"
#import "DetailViewController.h"
#import "PhotosetViewController.h"

#import "MJExtension.h"
#import "NSObject+Extension.h"
#import "MJRefresh.h"
#import "WSYNetworkTools.h"

@interface SingleNewsTableViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, strong) NSString *currentUrl;
@end

@implementation SingleNewsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    self.tableView.showsVerticalScrollIndicator = NO;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self setUrlString:self.currentUrl];
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing {
    NSLog(@"%@", self.currentUrl);
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@", self.currentUrl];
    NSString *str1 = [str substringWithRange:NSMakeRange(str.length - 7, 2)];
    int a = [str1 intValue];
    a += 20;
    NSString *str2 = [NSString stringWithFormat:@"%d", a];
    [str replaceOccurrencesOfString:str1 withString:str2 options:NSCaseInsensitiveSearch range:NSMakeRange(str.length - 7, 2)];
    NSLog(@"%@", str);
    self.currentUrl = str;
    [self setUrlString:str];
    [self.tableView reloadData];
    [self.tableView footerEndRefreshing];
}

- (void)setUrlString:(NSString *)urlString {
    self.currentUrl = urlString;
    [[[WSYNetworkTools sharedNetworkTools] GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        self.newsList = [NSMutableArray arrayWithArray:[SingleModel objectArrayWithKeyValuesArray:responseObject[key]]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }] resume];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleModel *news = self.newsList[indexPath.row];
    NSString *ID = [SingleNewsCell cellIDWithModel:news];
    if (indexPath.row == 0) {
        SingleNewsHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        headerCell.newsModel = news;
        return headerCell;
    } else {
        SingleNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.newsModel = news;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleModel *news = self.newsList[indexPath.row];
    if (indexPath.row == 0) {
        return [SingleNewsHeaderCell rowHeight];
    } else {
        return [SingleNewsCell rowHeightWithModel:news];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
    SingleModel *single = self.newsList[indexPath.row];
    if (single.photosetID) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Photoset" bundle:nil];
        PhotosetViewController *newsPhotoset = sb.instantiateInitialViewController;
        newsPhotoset.singleModel = single;
        [self.view.window.rootViewController presentViewController:newsPhotoset animated:YES completion:nil];
    } else {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DetailView" bundle:nil];
        DetailViewController *newsDetails = sb.instantiateInitialViewController;
        newsDetails.singleModel = single;
        DetailNavigationController *dNavi = [[DetailNavigationController alloc] initWithRootViewController:newsDetails];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCustom;
        // 过渡的delegate
        //    self.view.window.rootViewController.transitioningDelegate = [ZLTransitioning sharedTransitioning];
        
        [self.view.window.rootViewController presentViewController:dNavi animated:YES completion:nil];
//            UINavigationController *navi = (UINavigationController *)self.view.window.rootViewController;
//            [navi pushViewController:newsDetails animated:YES];
    }
    
}
@end