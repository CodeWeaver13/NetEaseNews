//
//  CollectionViewCell.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
/**
 *  用于传递的url
 */
@property (nonatomic, copy) NSString *urlString;
@end
