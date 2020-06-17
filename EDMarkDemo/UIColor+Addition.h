//
//  UIColor+Addition.h
//  Communication
//
//  Created by andy on 14-8-20.
//  Copyright (c) 2014年 wangfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

+ (UIColor *)colorWithHex:(NSInteger)hex;

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end
