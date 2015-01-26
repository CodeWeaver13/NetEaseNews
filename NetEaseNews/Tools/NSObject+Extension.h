//
//  NSObject+Extension.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
@end
