//
//  NSString+StringExt.h
//  QQ
//
//  Created by wangshiyu13 on 14/12/14.
//  Copyright (c) 2014年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (StringExt)
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end