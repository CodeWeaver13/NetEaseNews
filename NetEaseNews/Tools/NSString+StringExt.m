//
//  NSString+StringExt.m
//  QQ
//
//  Created by wangshiyu13 on 14/12/14.
//  Copyright (c) 2014年 wangshiyu13. All rights reserved.
//

#import "NSString+StringExt.h"
@implementation NSString (StringExt)

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

@end
