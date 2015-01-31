//
//  TitleLabel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "TitleLabel.h"

static const CGFloat NormalSize = 14.0f;
static const CGFloat SelectSize = 20.0f;

#define NormalFont [UIFont systemFontOfSize:NormalSize]
#define SelectedFont [UIFont systemFontOfSize:SelectSize]

static const int NormalRed = 0;
static const int NormalGreen = 0;
static const int NormalBlue = 0;

static const int SelectedRed = 255;
static const int SelectedGreen = 0;
static const int SelectedBlue = 0;

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface TitleLabel()
@property (nonatomic, assign) int red;
@property (nonatomic, assign) int green;
@property (nonatomic, assign) int blue;
@end

@implementation TitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.red = NormalRed;
        self.green = NormalGreen;
        self.blue = NormalBlue;
        self.textColor = Color(NormalRed, NormalGreen, NormalBlue);
        self.font = NormalFont;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
//    self.font = selected ? SelectedFont : NormalFont;
    
    if (selected) {
        self.red = SelectedRed;
        self.green = SelectedGreen;
        self.blue = SelectedBlue;
    } else {
        self.red = NormalRed;
        self.green = NormalGreen;
        self.blue = NormalBlue;
    }
    self.textColor = Color(self.red, self.green, self.blue);
}

- (void)adjust:(CGFloat)percent {
    NSLog(@"%f", percent);
    // 调整文字大小
    CGFloat size = (SelectSize / NormalSize) - 1;
    CGFloat value = size * percent;
    NSLog(@"value ---- %f", value);
    self.transform = CGAffineTransformMakeScale(1 + value, 1 + value);

//    self.transform = CGAffineTransformMakeScale((SelectSize / NormalSize), (SelectSize / NormalSize));
    
    // 调整颜色
    self.red = NormalRed + (SelectedRed - NormalRed) * percent;
    self.green = NormalGreen + (SelectedGreen - NormalGreen) * percent;
    self.blue = NormalBlue + (SelectedBlue - NormalBlue) * percent;
    self.textColor = Color(self.red, self.green, self.blue);
}

@end