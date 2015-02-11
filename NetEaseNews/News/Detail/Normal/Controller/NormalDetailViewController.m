//
//  NormalDetailViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "NormalDetailViewController.h"
#import "NormalDetailModel.h"
#import "NormalImageModel.h"
#import "NormalVideoModel.h"
#import "SingleModel.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "WSYNetworkTools.h"
#import "MJExtension.h"
#import "NSObject+Extension.h"
#import "NSString+StringExt.h"
#import "StatusBarHUD.h"
#import <WebKit/WebKit.h>

@interface NormalDetailViewController () <UIWebViewDelegate>
@property (nonatomic, strong) NormalDetailModel *detail;
@end

@implementation NormalDetailViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self loadData];
}

- (void)viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear: animated];
    if (![[self.navigationController viewControllers] containsObject: self]) {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController popViewControllerAnimated:YES];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 设置导航栏
- (void)setupNavigation {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.title = @"新闻详情";
    /** 自定义返回按钮 */
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"top_navigation_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"top_navigation_back_highlighted"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];
    
    /** 设置右侧评论按钮 */
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *str = [NSString stringWithFormat:@"%@跟帖", self.singleModel.replyCount];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(120, 40)];
    rightBtn.frame = CGRectMake(0, 0, size.width + 20, 40);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitle:str forState:UIControlStateNormal];
    [rightBtn needsUpdateConstraints];
    UIImage *normalImg = [UIImage imageNamed:@"contentview_commentbacky"];
    UIImage *highlightedImg = [UIImage imageNamed:@"contentview_commentbacky_selected"];
    CGFloat normalW = normalImg.size.width;
    CGFloat normalH = normalImg.size.height;
    CGFloat highW = highlightedImg.size.width;
    CGFloat highH = highlightedImg.size.height;
    normalImg = [normalImg resizableImageWithCapInsets:UIEdgeInsetsMake(normalH * 0.5, normalW * 0.5, normalH * 0.5, normalW * 0.5)];
    highlightedImg = [highlightedImg resizableImageWithCapInsets:UIEdgeInsetsMake(highH * 0.5, highW * 0.5, highH * 0.5, highW * 0.5)];
    [rightBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 15);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
}

#pragma mark - 返回按钮点击事件
- (void)back {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController popViewControllerAnimated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 加载webView数据
- (void)loadData {
    // 发送一个GET请求, 获得新闻的详情数据
    NSString *url = [NSString stringWithFormat:@"/nc/article/%@/full.html", self.singleModel.docid];
    [[WSYNetworkTools sharedNetworkTools] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        self.detail = [NormalDetailModel objectWithKeyValues:responseObject[self.singleModel.docid]];
        NSString *html = [self loadHTMLByMGTempEngine:self.detail];
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [web loadHTMLString:html baseURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"content" ofType:@"css"]]];
        [self.view addSubview:web];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

/** 调用MGTemplateEngine用于渲染网页 */
- (NSString *)loadHTMLByMGTempEngine:(NormalDetailModel *)data {
    NSString *tempPath = [[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"];
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    if (data.ptime) {        
        NSString *newptime = [data.ptime substringWithRange:NSMakeRange(6, 10)];
        [engine setObject:newptime forKey:@"ptime"];
    }
    if (data.body) {
        NSString *newbody = [self setupBody:data.body];
        [engine setObject:newbody forKey:@"body"];
    }
    if (data.title) [engine setObject:data.title forKey:@"title"];
    if (data.source) [engine setObject:data.source forKey:@"source"];
    if (data.source_url) [engine setObject:data.source_url forKey:@"source_url"];
    if (data.app) [engine setObject:data.app forKey:@"app"];
    if (data.replyBoard) [engine setObject:data.replyBoard forKey:@"replyBoard"];
    if (data.link) [engine setObject:data.link forKey:@"link"];
    if (data.tid) [engine setObject:data.tid forKey:@"tid"];
    if (data.boboList) [engine setObject:data.boboList forKey:@"boboList"];
    if (data.img) [engine setObject:data.img forKey:@"img"];
    if (data.topiclist_news) [engine setObject:data.topiclist_news forKey:@"topiclist_news"];
    if (data.picnews) [engine setObject:data.picnews forKey:@"picnews"];
    if (data.relative) [engine setObject:data.relative forKey:@"relative"];
    if (data.replyCount) [engine setObject:data.replyCount forKey:@"replyCount"];
    if (data.docid) [engine setObject:data.docid forKey:@"docid"];
    if (data.hasNext) [engine setObject:data.hasNext forKey:@"hasNext"];
    if (data.topiclist) [engine setObject:data.topiclist forKey:@"topiclist"];
    if (data.votes) [engine setObject:data.votes forKey:@"votes"];
    if (data.voicecomment) [engine setObject:data.voicecomment forKey:@"voicecomment"];
    if (data.users) [engine setObject:data.users forKey:@"users"];
    return [engine processTemplateInFileAtPath:tempPath withVariables:nil];
}

/** 初始化body内容 */
- (NSString *)setupBody:(NSString *)oldBody {
    NSMutableString *body = [NSMutableString string];
    [body appendString:oldBody];
    // 拼接图片
    for (NormalImageModel *img in self.detail.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        [imgHtml appendString:@"<div class=\"img-paresent\">"];
        
        NSString *onload = @"this.onclick = function() {"
        "   window.location.href = 'hm:saveImageToAlbum:&' + this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" src=\"%@\">", onload, (int)[UIScreen mainScreen].bounds.size.width - 20, img.src];
        [imgHtml appendString:@"</div><br/>"];
        // 将img.ref替换为img标签的内容
        [body replaceOccurrencesOfString:@"　" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        [body replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    for (NormalVideoModel *video in self.detail.video) {
        NSMutableString *videoHtml = [NSMutableString string];
        [videoHtml appendString:@"<div>"];
        [videoHtml appendFormat:@"<video width=\"%d\" controls preload=\"auto\" poster=\"%@\"> <source src=\"%@\" codecs=\"avc1.42E01E, mp4a.40.2\"  type=\"video/mp4\">", (int)[UIScreen mainScreen].bounds.size.width - 20, video.cover, video.url_m3u8];
        [videoHtml appendString:@"</div><br/>"];
        [body replaceOccurrencesOfString:video.ref withString:videoHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

/** 保存图片到相册 */
- (void)saveImageToAlbum:(NSString *)src {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"是否要保存图片到相册?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // UIWebView的缓存由NSURLCache来管理
        NSURLCache *cache = [NSURLCache sharedURLCache];
        // 从网页缓存中取得图片
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        // 保存图片
        UIImage *image = [UIImage imageWithData:imgData];
        // 调用HUD
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:withError:info:), nil);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
    // 显示
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"hm:"];
    if (range.location != NSNotFound) {
        NSUInteger loc = range.location + range.length;
        NSString *path = [url substringFromIndex:loc];
        // 获得方法和参数
        NSArray *methodNameAndParam = [path componentsSeparatedByString:@"&"];
        // 方法名
        NSString *methodName = [methodNameAndParam firstObject];
        // 调用方法
        SEL selector = NSSelectorFromString(methodName);
        if ([self respondsToSelector:selector]) { // 判断方法的目的： 防止因为方法不存在而报错
            NSMutableArray *params = nil;
            if (methodNameAndParam.count > 1) { // 方法有参数
                params = [NSMutableArray arrayWithArray:methodNameAndParam];
                // 从数组中去掉方法名
                [params removeObjectAtIndex:0];
            }
            [self performSelector:selector withObjects:params];
        }
        return NO;
    }
    return YES;
}

- (void)image:(UIImage *)image withError:(NSError *)error info:(void *)contextInfo; {
    // 提醒用户图片保存成功还是失败
    if (error) { // 图片保存失败
        [StatusBarHUD showError:@"图片保存失败"];
    } else { // 图片保存成功
        [StatusBarHUD showSuccess:@"图片保存成功"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __func__);
}

@end