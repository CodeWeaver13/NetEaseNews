//
//  WSYNetworkTools.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/21.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "WSYNetworkTools.h"
@implementation WSYNetworkTools
+ (instancetype)sharedNetworkTools {
    static WSYNetworkTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        tools = [[WSYNetworkTools alloc] initWithBaseURL:url sessionConfiguration:config];
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return tools;
}
@end
