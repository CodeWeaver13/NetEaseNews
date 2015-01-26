//
//  TitleCollectionBarCell.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "TitleCollectionBarCell.h"
#import "SingleModel.h"
#import "NSString+StringExt.h"

@interface TitleCollectionBarCell()

@end
@implementation TitleCollectionBarCell
#pragma mark - 实例化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TitleCell" owner:self options: nil];
    if(arrayOfViews.count < 1) return nil;
    if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) return nil;
    self = [arrayOfViews objectAtIndex:0];
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.tNameBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.tNameBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.tNameBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.bounds = self.tNameBtn.bounds;
}

#pragma mark - 设置按钮模型
- (void)setModel:(SingleModel *)model {
    _model = model;
    _tNameBtn.selected = NO;
    NSString *tname = model.tname;
    CGSize textSize = [tname sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 30)];
    [_tNameBtn setTitle:tname forState:UIControlStateNormal];
    _tNameBtn.transform = CGAffineTransformIdentity;
    _tNameBtn.bounds = CGRectMake(0, 0, textSize.width + 10, 30);
    self.bounds = CGRectMake(0, 0, _tNameBtn.bounds.size.width + 10, 30);
}
@end