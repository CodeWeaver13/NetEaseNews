//
//  BaseViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/23.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()
@property (weak, nonatomic) IBOutlet UIView *collectionViewContain;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)setupNavigation {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *headerImage = [UIImage imageNamed:@"home_header_logo"];
    headerImage = [headerImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:headerImage];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    titleView.bounds = CGRectMake(0, 0, 40, 25);
    self.navigationItem.titleView = titleView;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"top_navigation_back"]];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *leftImage = [UIImage imageNamed:@"night_top_navigation_menuicon"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"night_top_navigation_menuicon_highlighted"] forState:UIControlStateHighlighted];
    leftBtn.bounds = CGRectMake(-5, 0, 35, 35);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

@end
