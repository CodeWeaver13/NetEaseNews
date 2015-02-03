//
//  TitleLabel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "TitleLabel.h"

static const CGFloat NormalSize = 14.0f;
static const CGFloat SelectSize = 18.0f;
@implementation TitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.font = [UIFont systemFontOfSize:NormalSize];
        self.textAlignment = NSTextAlignmentCenter;
        self.change = 0.0;
    }
    return self;
}

- (void)setChange:(CGFloat)change {
    // 调整文字大小
    CGFloat size = (SelectSize / NormalSize) - 1;
    CGFloat value = size * change;
    self.transform = CGAffineTransformMakeScale(1 + value, 1 + value);
    
    // 调整颜色
    self.textColor = [UIColor colorWithRed:change green:0.0 blue:0.0 alpha:1.0];
}

@end