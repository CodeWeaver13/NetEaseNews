//
//  SingleNewsCell.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "SingleNewsCell.h"
#import "SingleModel.h"
#import "UIImageView+WebCache.h"
@interface SingleNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *digestLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView2;

@end
@implementation SingleNewsCell

+ (NSString *)cellIDWithModel:(SingleModel *)news {
    if (news.imgType) {
        return @"HugeImageCell";
    } else if (news.imgextra) {
        return @"TripleImageCell";
    } else {
        return @"NewsCell";
    }
}

+ (CGFloat)rowHeightWithModel:(SingleModel *)news {
    if (news.imgType) {
        return 180;
    } else if (news.imgextra) {
        return 120;
    } else {
        return 80;
    }
}

- (void)setNewsModel:(SingleModel *)newsModel {
    _newsModel = newsModel;
    
    self.titleLabel.text = newsModel.title;
    self.digestLabel.text = newsModel.digest;
    self.replyLabel.text = [NSString stringWithFormat:@"%@跟贴", newsModel.replyCount];
    
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc]];
    
    // 多图
    if (newsModel.imgextra.count == 2) {
        [self.newsImageView1 sd_setImageWithURL:[NSURL URLWithString:newsModel.imgextra[0][@"imgsrc"]]];
        [self.newsImageView2 sd_setImageWithURL:[NSURL URLWithString:newsModel.imgextra[1][@"imgsrc"]]];
    }
}
@end
