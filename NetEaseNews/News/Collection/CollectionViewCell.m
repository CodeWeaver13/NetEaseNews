//
//  CollectionViewCell.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "CollectionViewCell.h"
#import "SingleNewsTableViewController.h"

@interface CollectionViewCell()
@property (nonatomic, strong) SingleNewsTableViewController *newsVC;
@end
@implementation CollectionViewCell

- (void)awakeFromNib {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Single" bundle:nil];
    self.newsVC = sb.instantiateInitialViewController;
    self.bounds = self.newsVC.view.bounds;
    [self addSubview:self.newsVC.view];
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    self.newsVC.urlString = urlString;
}
@end