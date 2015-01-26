//
//  DetailModel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "DetailModel.h"
#import "DetailImageModel.h"
@implementation DetailModel
- (NSDictionary *)objectClassInArray {
    return @{@"img" : [DetailImageModel class]};
}
@end
