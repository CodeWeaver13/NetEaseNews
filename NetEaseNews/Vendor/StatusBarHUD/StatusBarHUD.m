//
//  HMStatusBarHUD.m
//  02-新闻详情页面
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 heima. All rights reserved.
//

// 窗口的高度
#define HMWindowHeight 20

// 动画的执行时间
#define HMDuration 0.5

// 窗口的停留时间
#define HMDelay 1.5

// 文字字体
#define HMFont [UIFont systemFontOfSize:12]

#import "StatusBarHUD.h"

@implementation StatusBarHUD

// 全局变量
UIWindow *_window;

/**
 *  显示信息
 *
 *  @param msg   信息
 *  @param image 图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image
{
    if (_window) return;
    
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 按钮文字大小
    btn.titleLabel.font = HMFont;
    // 切掉文字左边的10
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // 设置数据
    [btn setTitle:msg forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    
    // 创建窗口
    _window = [[UIWindow alloc] init];
    // 窗口背景
    _window.backgroundColor = [UIColor blackColor];
    _window.windowLevel = UIWindowLevelAlert;
    _window.frame = CGRectMake(0, -HMWindowHeight, [UIScreen mainScreen].bounds.size.width, HMWindowHeight);
    btn.frame = _window.bounds;
    [_window addSubview:btn];
    // 显示窗口
    _window.hidden = NO;
    
    // 窗口的级别，级别高的覆盖在级别低的window上
    // UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    
    // 动画
    [UIView animateWithDuration:HMDuration animations:^{
        CGRect frame = _window.frame;
        frame.origin.y = 0;
        _window.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:HMDuration delay:HMDelay options:kNilOptions animations:^{
            CGRect frame = _window.frame;
            frame.origin.y = - HMWindowHeight;
            _window.frame = frame;
        } completion:^(BOOL finished) {
            _window = nil;
        }];
    }];
}

/**
 *  显示信息
 *
 *  @param msg   信息
 *  @param imageName 图片
 */
+ (void)showMessage:(NSString *)msg imageName:(NSString *)imageName
{
    [self showMessage:msg image:[UIImage imageNamed:imageName]];
}

/**
 *  显示成功信息
 *
 *  @param msg 信息
 */
+ (void)showSuccess:(NSString *)msg
{
    [self showMessage:msg imageName:@"StatusBarHUD.bundle/success"];
}

/**
 *  显示失败信息
 *
 *  @param msg 信息
 */
+ (void)showError:(NSString *)msg
{
    [self showMessage:msg imageName:@"StatusBarHUD.bundle/error"];
}

/**
 *  显示加载信息
 *
 *  @param msg 信息
 */
+ (void)showLoading:(NSString *)msg
{
    if (_window) return;
    
    // 创建窗口
    _window = [[UIWindow alloc] init];
    // 窗口背景
    _window.backgroundColor = [UIColor blackColor];
    _window.windowLevel = UIWindowLevelAlert;
    _window.frame = CGRectMake(0, - HMWindowHeight, [UIScreen mainScreen].bounds.size.width, HMWindowHeight);
    // 显示窗口
    _window.hidden = NO;
    
    // 文字
    UILabel *label = [[UILabel alloc] init];
    label.frame = _window.bounds;
    label.font = HMFont;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_window addSubview:label];
    
    // 圈圈
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating];
    indicatorView.frame = CGRectMake(0, 0, HMWindowHeight, HMWindowHeight);
    [_window addSubview:indicatorView];
    
    // 动画
    [UIView animateWithDuration:HMDuration animations:^{
        CGRect frame = _window.frame;
        frame.origin.y = 0;
        _window.frame = frame;
    }];
}

/**
 *  隐藏加载信息
 */
+ (void)hideLoading
{
    [UIView animateWithDuration:HMDuration animations:^{
        CGRect frame = _window.frame;
        frame.origin.y = - HMWindowHeight;
        _window.frame = frame;
    } completion:^(BOOL finished) {
        _window = nil;
    }];
}
@end
