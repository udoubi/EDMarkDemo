//
//  EDDrawDotButton.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawDotButton.h"

@implementation EDDrawDotButton

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = 1;
    
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rect.size.width / 2 - width / 2, 0, M_PI * 2, 0);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rect.size.width / 2, 0, M_PI * 2, 0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    if (self.color) {
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), self.radius, 0, M_PI * 2, 0);
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextDrawPath(context, kCGPathFill);
    }

    if (self.image) {
        [self.image drawInRect:rect];
    }
    
    if (self.selected) {
        width = 2;
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rect.size.width / 2 - width / 2, 0, M_PI * 2, 0);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

//- (void)setImage:(UIImage *)image forState:(UIControlState)state
//{
//    [super setImage:image forState:state];
//
//}
//- (void)setSelected:(BOOL)selected
//{
//    if (selected) {
//        self.layer.borderWidth = 2;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
//    }else{
//        self.layer.borderWidth = 0;
//        self.layer.borderColor = nil;
//        self.layer.cornerRadius = 0;
//    }
//}
@end
