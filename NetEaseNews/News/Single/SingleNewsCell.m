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

/**
 *  绘制ell的底边线
 */
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    [bPath moveToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 1)];
    [bPath addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - 1)];
    bPath.lineWidth = 0.05;
    [bPath stroke];
}

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
        return 200;
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
    if (newsModel.replyCount.intValue >= 10000) {
        NSString *replyStr = [NSString stringWithFormat:@"%.1f万跟贴", (newsModel.replyCount.intValue * 0.0001)];
        self.replyLabel.text = replyStr;
    } else {
        NSString *replyStr = [NSString stringWithFormat:@"%d跟贴", newsModel.replyCount.intValue];
        self.replyLabel.text = replyStr;
    }

    self.newsImageView.alpha = 0.1;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.5 animations:^{
            self.newsImageView.alpha = 1;
        }];
    }];
    
    // 多图
    if (newsModel.imgextra.count == 2) {
        self.newsImageView1.alpha = 0.1;
        [self.newsImageView1 sd_setImageWithURL:[NSURL URLWithString:newsModel.imgextra[0][@"imgsrc"]]placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:0.5 animations:^{
                self.newsImageView1.alpha = 1;
            }];
        }];
        self.newsImageView2.alpha = 0.1;
        [self.newsImageView2 sd_setImageWithURL:[NSURL URLWithString:newsModel.imgextra[1][@"imgsrc"]]placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView animateWithDuration:0.5 animations:^{
                self.newsImageView2.alpha = 1;
            }];
        }];
    }
}
@end
