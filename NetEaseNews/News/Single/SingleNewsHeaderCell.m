//
//  SingleNewsHeaderCell.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "SingleNewsHeaderCell.h"
#import "SingleModel.h"
#import "UIImageView+WebCache.h"
@interface SingleNewsHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation SingleNewsHeaderCell

- (void)awakeFromNib {
    // Initialization code HeaderCell
}

+ (CGFloat)rowHeight {
    return 230;
}

- (void)setNewsModel:(SingleModel *)newsModel {
    _newsModel = newsModel;
    
    self.titleLabel.text = newsModel.title;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc]placeholderImage:nil options:SDWebImageContinueInBackground];
}

@end
