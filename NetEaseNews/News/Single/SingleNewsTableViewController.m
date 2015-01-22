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
#import "WSYNetworkTools.h"
@interface SingleNewsTableViewController ()
@property (nonatomic, strong) NSArray *newsList;
@end

@implementation SingleNewsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.bounds = CGRectMake(0, 0, 320, 568);
}

- (void)setNewsList:(NSArray *)newsList {
    _newsList = newsList;
    
    [self.tableView reloadData];
}

- (void)setUrlString:(NSString *)urlString {
    
    [[[WSYNetworkTools sharedNetworkTools] GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        NSString *key = [responseObject.keyEnumerator nextObject];
        NSArray *dataList = responseObject[key];
        
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dataList.count];
        [dataList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [arrayM addObject:[SingleModel singleModelWithDict:obj]];
        }];
        self.newsList = arrayM;
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
    
    SingleNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.newsModel = news;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SingleModel *news = self.newsList[indexPath.row];
    
    return [SingleNewsCell rowHeightWithModel:news];
}

@end
