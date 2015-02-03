//
//  NormalDetailModel.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface NormalDetailModel : NSObject
/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;
/** 新闻配图(希望这个数组中以后放DetailImg模型) */
@property (nonatomic, strong) NSArray *img;
/** 新闻视频(希望这个数组中以后放DetailVideo模型) */
@property (nonatomic, strong) NSArray *video;
// 来源
@property (nonatomic, copy) NSString *source;
// apps
@property (nonatomic, strong) NSArray *app;
// link
@property (nonatomic, strong) NSArray *link;
// tid
@property (nonatomic, copy) NSString *tid;
// boboList
@property (nonatomic, strong) NSArray *boboList;
// topiclist_news
@property (nonatomic, strong) NSArray *topiclist_news;

@property (nonatomic, copy) NSNumber *picnews;

@property (nonatomic, copy) NSString *template;

@property (nonatomic, strong) NSArray *relative;

@property (nonatomic, copy) NSNumber *replyCount;

@property (nonatomic, copy) NSString *source_url;

@property (nonatomic, copy) NSString *docid;

@property (nonatomic, copy) NSString *replyBoard;

@property (nonatomic, copy) NSNumber *hasNext;

@property (nonatomic, strong) NSArray *topiclist;

@property (nonatomic, strong) NSArray *votes;

@property (nonatomic, copy) NSString *voicecomment;

@property (nonatomic, strong) NSArray *users;

@property (nonatomic, copy) NSString *digest;
@end
