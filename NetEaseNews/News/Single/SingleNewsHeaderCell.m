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
+ (CGFloat)rowHeight {
    return 226;
}

- (void)setNewsModel:(SingleModel *)newsModel {
    _newsModel = newsModel;
    self.titleLabel.text = newsModel.title;
    
    self.headerImageView.alpha = 0.1;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"recommend_image_bg"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.5 animations:^{
            self.headerImageView.alpha = 1;
        }];
    }];
}
@end
