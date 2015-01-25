//
//  CollectionViewController.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/22.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^myCollBlock)(NSIndexPath *indexPath);
@interface CollectionViewController : UICollectionViewController
@property (nonatomic, copy) myCollBlock collBlock;

@end
