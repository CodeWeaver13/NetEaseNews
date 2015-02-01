//
//  UIImage+Scale.h
//  NetEaseNews
//
//  Created by wangshiyu13 on 15/2/2.
//  Copyright (c) 2015年 wangshiyu13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
