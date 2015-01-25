//
//  ChannelModel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "ChannelModel.h"
#import "WSYNetworkTools.h"
#import "SingleModel.h"
@implementation ChannelModel
+ (instancetype)channelModelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

static int a = 0;
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValue:@"cName" forKey:@"cName"];
        [self setValue:@"cid" forKey:@"cid"];
        NSArray *dicts = dict[@"tList"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dicts.count];
        for (NSDictionary *dict in dicts) {
            SingleModel *single = [SingleModel singleModelWithDict:dict];
            [arrayM addObject:single];
            single.titleTag = a;
            a++;
        }
        self.tList = arrayM;
    }
    return self;
}
@end
