//
//  DetailViewController.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
#import "DetailImageModel.h"
#import "SingleModel.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "WSYNetworkTools.h"
#import "MJExtension.h"
#import "NSObject+Extension.h"
#import "StatusBarHUD.h"

@interface DetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) DetailModel *detail;
@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻详情";
    [self setupNavigation];
    [self loadData];
}

- (void)loadData {
    // 发送一个GET请求, 获得新闻的详情数据
    NSString *url = [NSString stringWithFormat:@"/nc/article/%@/full.html", self.singleModel.docid];
    [[WSYNetworkTools sharedNetworkTools] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        self.detail = [DetailModel objectWithKeyValues:responseObject[self.singleModel.docid]];
        NSString *html = [self loadHTMLByMGTempEngine:self.detail];
        [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"content" ofType:@"css"]]];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (NSString *)loadHTMLByMGTempEngine:(DetailModel *)data {
    NSString *tempPath = [[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"];
    NSLog(@"%@", tempPath);
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    if (data.title) {
        [engine setObject:data.title forKey:@"title"];
    }
    if (data.source) {
        [engine setObject:data.source forKey:@"source"];
    }
    if (data.ptime) {        
        NSString *newptime = [data.ptime substringWithRange:NSMakeRange(6, 10)];
        [engine setObject:newptime forKey:@"ptime"];
    }
    if (data.body) {
        NSString *newbody = [self setupBody:data.body];
        [engine setObject:newbody forKey:@"body"];        
    }
    if (data.source_url) {
        [engine setObject:data.source_url forKey:@"source_url"];
    }
    if (data.app) {
        [engine setObject:data.app forKey:@"app"];
    }
    if (data.replyBoard) {
        [engine setObject:data.replyBoard forKey:@"replyBoard"];
    }
    [engine setObject:data.link forKey:@"link"];
    [engine setObject:data.tid forKey:@"tid"];
    [engine setObject:data.boboList forKey:@"boboList"];
    [engine setObject:data.img forKey:@"img"];
    [engine setObject:data.topiclist_news forKey:@"topiclist_news"];
    [engine setObject:data.picnews forKey:@"picnews"];
    [engine setObject:data.relative forKey:@"relative"];
    [engine setObject:data.replyCount forKey:@"replyCount"];
    [engine setObject:data.docid forKey:@"docid"];
    [engine setObject:data.hasNext forKey:@"hasNext"];
    [engine setObject:data.topiclist forKey:@"topiclist"];
    [engine setObject:data.votes forKey:@"votes"];
    [engine setObject:data.voicecomment forKey:@"voicecomment"];
    [engine setObject:data.users forKey:@"users"];
    return [engine processTemplateInFileAtPath:tempPath withVariables:nil];
}

/**
 *  初始化body内容
 */
- (NSString *)setupBody:(NSString *)oldBody
{
    NSMutableString *body = [NSMutableString string];
    
    [body appendString:oldBody];
    // 拼接图片
    for (DetailImageModel *img in self.detail.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        [imgHtml appendString:@"<div class=\"img-pare   nt\">"];
        
        // img.pixel = 500*332
//        NSArray *pixel = [img.pixel componentsSeparatedByString:@"*"];
//        int width = [[pixel firstObject] intValue];
//        int height = [[pixel lastObject] intValue];
//        int maxWidth = [UIScreen mainScreen].bounds.size.width * 1.9;
//        if (width > maxWidth) { // 限制尺寸
//            height = height * maxWidth / width;
//            width = maxWidth;
//        }
//            height = height * maxWidth / width;
//            width = maxWidth;
//        }
        
        NSString *onload = @"this.onclick = function() {"
        "   window.location.href = 'hm:saveImageToAlbum:&' + this.src;"
        "};";
        
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" src=\"%@\">", onload, (int)[UIScreen mainScreen].bounds.size.width - 20, img.src];
        [imgHtml appendString:@"</div><br/>"];
        
        
//        [imgHtml appendFormat:@"<img src=\"%@\">", img.src];
//        [imgHtml appendString:@"</div><br/>"];

        // 将img.ref替换为img标签的内容
        [body replaceOccurrencesOfString:@"　" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        [body replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

/**
 *  保存图片到相册
        // 图片的html字符串
 *
 *  @param src 图片路径
 */
- (void)saveImageToAlbum:(NSString *)src
{
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
/**
 *  每当webView发送一个请求之前都会先调用这个方法
 *
 *  @param request        即将发送的请求
 *
 *  @return YES: 允许发送这个请求, NO: 禁止发送这个请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
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

- (void)image:(UIImage *)image withError:(NSError *)error info:(void *)contextInfo;
{
    // 提醒用户图片保存成功还是失败
    if (error) { // 图片保存失败
        [StatusBarHUD showError:@"图片保存失败"];
    } else { // 图片保存成功
        [StatusBarHUD showSuccess:@"图片保存成功"];
    }
}

- (void)setupNavigation {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"top_navigation_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"top_navigation_back_highlighted"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backNavigationItem];

    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightImage = [UIImage imageNamed:@"night_top_navigation_menuicon"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"night_top_navigation_menuicon_highlighted"] forState:UIControlStateHighlighted];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)backButtonClicked:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
@end
