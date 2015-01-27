//
//  SingleModel.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleModel : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 摘要信息
@property (nonatomic, copy) NSString *digest;
// 跟贴
@property (nonatomic, copy) NSNumber *replyCount;
// 图片资源
@property (nonatomic, copy) NSString *imgsrc;
// 多图数组
@property (nonatomic, strong) NSArray *imgextra;
// 新闻时间
@property (nonatomic, copy) NSString *ptime;
// 视频ID
@property (nonatomic, copy) NSString *videoID;
// 模版
@property (nonatomic, copy) NSString *template;
// 头条icid
@property (nonatomic, copy) NSString *topicid;
// 栏目中文名
@property (nonatomic, copy) NSString *tname;
// 是否有封面
@property (nonatomic, assign) BOOL hasCover;
// 英文名
@property (nonatomic, copy) NSString *alias;
// 子新闻数
@property (nonatomic, copy) NSString *subnum;
// order
@property (nonatomic, copy) NSNumber * recommendOrder;
// 新旧
@property (nonatomic, copy) NSNumber * isNew;
// 图片标示
@property (nonatomic, copy) NSString *img;
// 是否热门
@property (nonatomic, copy) NSNumber * isHot;
// 是否有图片
@property (nonatomic, assign) BOOL hasIcon;
// 标示
@property (nonatomic, copy) NSString *cid;
// recommend
@property (nonatomic, copy) NSString *recommend;
// headLine
@property (nonatomic, assign) BOOL headLine;
// color
@property (nonatomic, copy) NSString *color;
// 广告单
@property (nonatomic, copy) NSNumber *bannerOrder;
// 栏目拼音名
@property (nonatomic, copy) NSString *ename;
// showType
@property (nonatomic, copy) NSString *showType;
// tid
@property (nonatomic, copy) NSString *tid;
// 子标题
@property (nonatomic, copy) NSString *subtitle;
// 广告标题
@property (nonatomic, copy) NSString *adTitle;
// 移动端网址
@property (nonatomic, copy) NSString *url;
// PC端网址
@property (nonatomic, copy) NSString *url_3w;
// 新闻ID
@property (nonatomic, copy) NSString *docid;

@property (nonatomic, copy) NSString *photosetID;
@property (nonatomic, copy) NSNumber *hasHead;
@property (nonatomic, copy) NSNumber *hasImg;
@property (nonatomic, copy) NSString *lmodify;
@property (nonatomic, copy) NSString *skipType;
@property (nonatomic, copy) NSNumber *hasAD;
@property (nonatomic, copy) NSNumber *priority;
@property (nonatomic, copy) NSString *skipID;
@property (nonatomic, copy) NSNumber *order;
@property (nonatomic, copy) NSString *timeConsuming;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *TAG;
@property (nonatomic, strong) NSArray *editor;
@property (nonatomic, copy) NSNumber *imgType;
@property (nonatomic, copy) NSString *TAGS;
@property (nonatomic, copy) NSString *specialID;
@property (nonatomic, strong) NSArray *specialextra;

@end
