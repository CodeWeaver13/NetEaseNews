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

static UIButton *prevBtn;
@interface TitleCollectionBarCell()
@property (weak, nonatomic) UIButton *tNameBtn;
@end
@implementation TitleCollectionBarCell
#pragma mark - 实例化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.contentMode = UIViewContentModeCenter;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tNameBtn];
    return self;
}

- (UIButton *)tNameBtn {
    if (_tNameBtn == nil) {
        _tNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tNameBtn.bounds = CGRectMake(0, 0, 55, 32);
        _tNameBtn.backgroundColor = [UIColor clearColor];
        [_tNameBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_tNameBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _tNameBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tNameBtn;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    self.bounds = self.tNameBtn.frame;
}

#pragma mark - 设置按钮模型
- (void)setModel:(SingleModel *)model {
    _model = model;
    NSString *tname = model.tname;
    CGSize textSize = [tname sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 32)];
    [self.tNameBtn setTitle:tname forState:UIControlStateNormal];
    self.tNameBtn.tag = model.titleTag + 100;
    [self.tNameBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tNameBtn.bounds = CGRectMake(0, 0, textSize.width, 30);
    self.bounds = CGRectMake(0, 0, self.tNameBtn.bounds.size.width, 30);
    self.tNameBtn.center = CGPointMake(textSize.width * 0.5 + 10, 15);
}

#pragma mark - 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    btn.selected = YES;
    if (prevBtn && ![btn isEqual:prevBtn]) {
        prevBtn.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            prevBtn.transform = CGAffineTransformIdentity;
        }];
    }
    prevBtn = btn;
    // 按钮动画
    [self btnClickAni:btn];
#pragma mark = 用通知传btn.tag
    NSNumber *tag = [[NSNumber alloc] initWithInteger:btn.tag - 137];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseViewBtnTag" object:tag];
}

#pragma mark - 按钮动画
- (void)btnClickAni:(UIButton *)btn {
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }];
        }];
    }];
}
@end