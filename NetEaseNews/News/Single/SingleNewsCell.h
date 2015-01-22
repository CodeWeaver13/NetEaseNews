//
//  SingleNewsCell.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleModel;
@interface SingleNewsCell : UITableViewCell
/**
 *  根据模型返回可重用标示符号
 */
+ (NSString *)cellIDWithModel:(SingleModel *)news;

/**
 *  根据模型返回行高
 */
+ (CGFloat)rowHeightWithModel:(SingleModel *)news;

@property (nonatomic, strong) SingleModel *newsModel;
@end
