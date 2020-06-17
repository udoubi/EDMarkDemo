//
//  EDDrawTextView.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/1.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawTextView.h"
#import "UIColor+Addition.h"

@implementation EDDrawTextView


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGRect retRect = [self textBoundingRect];
    CGContextAddRect(context, retRect);
    CGContextSetLineWidth(context, 2.0);//线的宽度
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:0x8FC4FF].CGColor);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5].CGColor);
    CGContextAddRect(context, retRect);
    CGContextFillPath(context);
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect retRect = [self textBoundingRect];
    
    if (point.x >= CGRectGetMinX(retRect) && point.x <= CGRectGetMaxX(retRect) && point.y >= CGRectGetMinY(retRect) && point.y <= CGRectGetMaxY(retRect) ) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}


- (CGRect)textBoundingRect
{
    CGSize textSize = self.textLayout.textBoundingSize;
    textSize = CGSizeMake(textSize.width, textSize.height - 4);
    if (textSize.width < 62) {
        textSize = CGSizeMake(62, textSize.height);
    }
    if (textSize.height < 26) {
        textSize = CGSizeMake(textSize.width, 26);
    }
    textSize = CGSizeMake(textSize.width + 1, textSize.height + 1);
    return (CGRect){CGPointMake(1, 1),textSize};
}



@end
