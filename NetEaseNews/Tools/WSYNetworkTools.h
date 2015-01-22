//
//  WSYNetworkTools.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/21.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "AFHTTPSessionManager.h"
@interface WSYNetworkTools : AFHTTPSessionManager
+ (instancetype)sharedNetworkTools;
@end
