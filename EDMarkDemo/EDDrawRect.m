//
//  EDDrawRect.m
//  EDMarkDemo
//
//  Created by ke on 2020/5/27.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawRect.h"



@implementation EDDrawRect



- (id)initWithStartPoint:(struct CGPoint)arg1
{
    if (self = [super initWithStartPoint:arg1]) {
        _startPoint = arg1;
    }
    return self;
}


- (void)drawMove:(struct CGPoint)arg1
{
    _endPoint = arg1;
}


- (void)drawUp:(struct CGPoint)arg1
{
    _endPoint = arg1;
}

- (void)drawContent:(struct CGContext *)context
{
    if (_path) {
        CGPathRelease(_path);
    }
    _path = CGPathCreateMutable();
    CGPathMoveToPoint(_path, NULL, _startPoint.x, _endPoint.y);
    CGPathAddLineToPoint(_path, NULL, _startPoint.x, _startPoint.y);
    CGPathAddLineToPoint(_path, NULL, _endPoint.x, _startPoint.y);
    CGPathAddLineToPoint(_path, NULL, _endPoint.x, _endPoint.y);
    CGPathCloseSubpath(_path);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextAddPath(context, _path);
    
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
        
    CGContextStrokePath(context);
    
    if (self.selected) {
        CGContextAddPath(context, _path);
        CGContextSetStrokeColorWithColor(context, self.selectColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, self.selectLineWidth);//线的宽度
        CGContextStrokePath(context);
    }
}
- (BOOL)isValidFeatrue
{
    if (fabs(_endPoint.x - _startPoint.x) >= self.lineWidth +3 && fabs(_endPoint.y - _startPoint.y) >= self.lineWidth + 3) {
        return YES;
    }
    return NO;
}

- (bool)hitTest:(CGPoint)point
{
    
    CGFloat lineW = self.lineWidth / 2;

    BOOL hit = NO;
    if (point.x >= _startPoint.x - lineW && point.x <= _endPoint.x + lineW  && point.y >= _startPoint.y - lineW && point.y <= _endPoint.y + lineW) {
        
        if (point.x >= _startPoint.x + lineW && point.x <= _endPoint.x - lineW  && point.y >= _startPoint.y + lineW && point.y <= _endPoint.y + lineW) {
            
        }else{
            hit = YES;
        }
        
    }
    
    
    return  hit;
}
- (void)moveByOffset:(struct CGSize)offset endPoint:(struct CGPoint)arg2
{
    _startPoint.x += offset.width;
    _startPoint.y += offset.height;
    
    _endPoint.x += offset.width;
    _endPoint.y += offset.height;
}
- (void)moveEndedWithOffset:(CGSize)offset
{
    _endPoint.x += offset.width;
    _endPoint.y += offset.height;
}
- (BOOL)canMoveEnded
{
    return YES;
}
- (NSArray *)getToolKeyPoints
{
    NSArray *points = @[@(_startPoint),@(_endPoint),@(CGPointMake(_startPoint.x, _endPoint.y)),@(CGPointMake(_endPoint.x, _startPoint.y))];

    return points;
}
@end
