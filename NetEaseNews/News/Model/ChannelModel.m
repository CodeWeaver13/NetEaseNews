//
//  ChannelModel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "ChannelModel.h"
#import "SingleModel.h"
@implementation ChannelModel
+ (NSDictionary *)objectClassInArray {
    return @{@"tList" : [SingleModel class]};
}
@end
