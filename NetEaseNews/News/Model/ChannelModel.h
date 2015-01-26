//
//  ChannelModel.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModel : NSObject
@property (nonatomic, copy) NSString *cName;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, strong) NSArray *tList;
@end
