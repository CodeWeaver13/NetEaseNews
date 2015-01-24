//
//  TitleCollectionBarCell.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "TitleCollectionBarCell.h"
#import "BaseViewController.h"
#import "SingleModel.h"
@interface TitleCollectionBarCell()

@end
@implementation TitleCollectionBarCell
- (void)awakeFromNib {
    [self.tNameBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.tNameBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.tNameBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.bounds = self.tNameBtn.bounds;
}



@end
