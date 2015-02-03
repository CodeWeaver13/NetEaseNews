//
//  NormalDetailModel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "NormalDetailModel.h"
#import "NormalImageModel.h"
#import "NormalVideoModel.h"
@implementation NormalDetailModel
- (NSDictionary *)objectClassInArray {
    return @{@"img" : [NormalImageModel class], @"video" : [NormalVideoModel class]};
}
@end
