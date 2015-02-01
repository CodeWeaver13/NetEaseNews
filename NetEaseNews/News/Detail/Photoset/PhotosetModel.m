//
//  PhotosetModel.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/2/1.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "PhotosetModel.h"
#import "PhotosetPhotosModel.h"
@implementation PhotosetModel
- (NSDictionary *)objectClassInArray {
    return @{@"photos" : [PhotosetPhotosModel class]};
}

@end
