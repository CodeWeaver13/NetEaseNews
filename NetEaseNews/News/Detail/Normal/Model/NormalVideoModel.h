//
//  NormalVideoModel.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/2/2.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormalVideoModel : NSObject
@property (nonatomic, copy) NSString *url_m3u8;
@property (nonatomic, copy) NSString *ref;
@property (nonatomic, copy) NSString *alt;
@property (nonatomic, copy) NSString *commentboard;
@property (nonatomic, copy) NSString *commentid;
@property (nonatomic, copy) NSString *url_mp4;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *broadcast;
@property (nonatomic, copy) NSString *topicid;
@end
