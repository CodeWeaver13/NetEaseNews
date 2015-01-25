//
//  SingleNewsHeaderCell.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/24.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleModel;
@interface SingleNewsHeaderCell : UITableViewCell
/**
 *  根据模型返回行高
 */
+ (CGFloat)rowHeight;

@property (nonatomic, strong) SingleModel *newsModel;
@end
