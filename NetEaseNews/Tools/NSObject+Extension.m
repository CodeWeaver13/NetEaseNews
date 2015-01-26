//
//  NSObject+Extension.m
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/1/26.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        for (int i = 0; i < [objects count]; i++) {
            id obj = [objects objectAtIndex:i];
            [invocation setArgument:&obj atIndex:(i + 2)];
        }
        [invocation invoke];
        if (signature.methodReturnLength) {
            id anObj;
            [invocation getReturnValue:&anObj];
            return anObj;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}
@end
