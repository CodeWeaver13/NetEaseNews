//
//  BaseViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/23.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//
#import "WSYNetworkTools.h"
#import "MJExtension.h"
#import "NSObject+Extension.h"
#import "NSString+StringExt.h"
#import "UIView+Extension.h"

#import "SingleModel.h"
#import "ChannelModel.h"

#import "BaseViewController.h"
#import "TitleLabel.h"
#import "SingleNewsTableViewController.h"
@interface BaseViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) TitleLabel *titleLbl;
/** 存放标签 */
@property (weak, nonatomic) IBOutlet UIScrollView *labelsScrollView;
/** 存放具体的子控制器 */
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *arrow;
@property (nonatomic, strong) NSArray *tList;
@property (nonatomic, strong) NSArray *channelList;
@property (nonatomic, strong) NSArray *urlList;
@end

@implementation BaseViewController

#pragma mark - 懒加载模型数组
- (NSArray *)tList {
    if (_tList == nil) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (ChannelModel *channel in self.channelList) {
            NSArray *tListArray = channel.tList;
            for (int i = 0; i < tListArray.count; i++) {
                if ([tListArray[i] isKindOfClass:[SingleModel class]]) {
                    SingleModel *single = tListArray[i];
                    [arrayM addObject:single];
                }
            }
        }
        _tList = arrayM;
    }
    return _tList;
}

- (NSArray *)channelList {
    if (_channelList == nil) {
        NSArray *localArray = [ChannelModel objectArrayWithJSONData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"topic_news.json" withExtension:nil]]];
#warning mark - 判断未完成
        NSArray *netArray = [ChannelModel objectArrayWithJSONData:[NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://c.m.163.com/nc/topicset/ios/v4/subscribe/news/all.html"]] returningResponse:nil error:nil]];
        if ([localArray isEqualToArray:netArray]) {
            _channelList = localArray;
        } else {
            _channelList = netArray;
        }
    }
    return _channelList;
}

- (NSArray *)urlList {
    if (_urlList == nil) {
        NSArray *array = self.tList;
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.tList.count];
        for (SingleModel *single in array) {
            NSString *str = [NSString stringWithFormat:@"/nc/article/%@/%@/0-20.html", (single.headLine ? @"headline" : @"list"), single.tid];
            [arrayM addObject:str];
        }
        _urlList = arrayM;
    }
    return _urlList;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // scrollView的属性
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.labelsScrollView.showsHorizontalScrollIndicator = NO;
    self.labelsScrollView.showsVerticalScrollIndicator = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupChildViewController];
    [self setupTitle];
    [self setupHomePage];
}

#pragma mark - 添加导航栏
- (void)setupNavigation {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    [leftBtn sizeToFit];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftBarBtn];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightImage = [UIImage imageNamed:@"top_navigation_infoicon"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"top_navigation_infoicon_highlighted"] forState:UIControlStateHighlighted];
    [rightBtn sizeToFit];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarBtn];
}

#pragma mark - 添加子控制器
- (void)setupChildViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Single" bundle:nil];
    for (int i = 0; i < self.tList.count; i++) {
        SingleModel *singleModel = self.tList[i];
        SingleNewsTableViewController *single = sb.instantiateInitialViewController;
        single.title = singleModel.tname;
        single.urlString = self.urlList[i];
        [self addChildViewController:single];
        UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contentview_hd_loading_logo"]];
        back.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
        back.contentMode = UIViewContentModeCenter;
        back.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        [self.contentScrollView addSubview:back];
    }
    CGFloat contentsContentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentsContentW, 0);
}

#pragma mark - 添加标题栏
- (void)setupTitle {
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat viewW = 20;
    CGFloat titleY = 0;
    CGFloat titleH = 36;
    NSInteger count = self.childViewControllers.count;
    for (NSInteger i = 0; i < count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        
        // 添加标签
        TitleLabel *titleLbl = [[TitleLabel alloc] init];
        titleLbl.tag = i + 100;
        titleLbl.text = childVc.title;
        CGFloat titleW = [childVc.title sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(100, 36)].width;
        titleLbl.frame = CGRectMake(viewW, titleY, titleW, titleH);
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [titleLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        [self.labelsScrollView addSubview:titleLbl];
        viewW += (titleW + 20);
    }
    // 设置内容大小
    self.labelsScrollView.contentSize = CGSizeMake(viewW, 0);
    self.labelsScrollView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:0.8];
    // 添加右侧更多按钮
    UIImage *channelArr = [UIImage imageNamed:@"channel_nav_arrow"];
    [self.arrow setImage:channelArr forState:UIControlStateNormal];
    [self.arrow setImage:channelArr forState:UIControlStateSelected];
    self.arrow.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    [self.arrow addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 启动加载首页
- (void)setupHomePage {
    SingleNewsTableViewController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:firstVc.view];
    TitleLabel *titleLabel = self.labelsScrollView.subviews[0];
    if ([titleLabel respondsToSelector:@selector(setChange:)]) {
        titleLabel.change = 1.0;
        self.titleLbl = titleLabel;
    }
}

#pragma mark - 私有方法 监听按钮点击
- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    TitleLabel *label = (TitleLabel *)recognizer.view;
    self.titleLbl.change = 0.0;
    label.change = 1.0;
    self.titleLbl = label;
    CGFloat offsetX = (label.tag - 100) * self.contentScrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, self.contentScrollView.contentOffset.y);
    [self.contentScrollView setContentOffset:offset animated:NO];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    TitleLabel *label = self.labelsScrollView.subviews[index];
    
    // 标题栏的动画效果
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger oneIndex = (NSUInteger)value;
    NSUInteger twoIndex = oneIndex + 1;
    CGFloat twoPercent = value - oneIndex;
    CGFloat onePercent = 1 - twoPercent;
    if (twoIndex < self.labelsScrollView.subviews.count) {
        TitleLabel *twoLabel = self.labelsScrollView.subviews[twoIndex];
        twoLabel.change = twoPercent;
    }
    label.change = onePercent;
    self.titleLbl = label; // 记得随时记录当前的按钮状态
    
    CGFloat titlesW = self.labelsScrollView.frame.size.width;
    CGFloat offsetX = label.center.x - titlesW * 0.5;
    
    // 最大的偏移量
    CGFloat maxOffsetX = self.labelsScrollView.contentSize.width - titlesW;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    CGPoint offset = CGPointMake(offsetX, self.labelsScrollView.contentOffset.y);
    [self.labelsScrollView setContentOffset:offset animated:YES];
    
    SingleNewsTableViewController *vc = self.childViewControllers[index];
    if (vc.view.superview) return;
    
    // 添加表格视图
    CGFloat vcW = scrollView.frame.size.width;
    CGFloat vcH = scrollView.frame.size.height;
    CGFloat vcX = index * vcW;
    CGFloat vcY = 0;
    vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
    [scrollView addSubview:vc.view];
}

/** 当scrollView减速完毕时调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

#pragma mark - 更多按钮点击事件
static float pi = -M_PI;
- (void)moreBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        sender.selected = !sender.selected;
        pi = -pi;
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, pi);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __func__);
}

@end
