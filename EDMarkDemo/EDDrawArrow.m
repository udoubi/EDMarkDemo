//
//  EDDrawArrow.m
//  EDMarkDemo
//
//  Created by ke on 2020/5/27.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawArrow.h"

@implementation EDDrawArrow



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
    CGContextTranslateCTM(context, _startPoint.x, _startPoint.y);
    
    CGPoint newEndPont = CGPointMake(_endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    CGFloat length = sqrt( pow(fabs(newEndPont.x), 2) + pow(fabs(newEndPont.y), 2) );
    if (length < 10) {
        return;
    }
    CGFloat angle = 0.0;
    if (newEndPont.x > 0 && newEndPont.y >= 0) {
        angle = atan(fabs(newEndPont.y / newEndPont.x * 1.0));
    }else if (newEndPont.x <= 0 && newEndPont.y > 0){
        angle = atan(fabs(newEndPont.x / newEndPont.y * 1.0)) + M_PI_2;
    }else if (newEndPont.x < 0 && newEndPont.y <= 0){
        angle = atan(fabs(newEndPont.y / newEndPont.x * 1.0)) + M_PI;
    }else if (newEndPont.x >= 0 && newEndPont.y < 0){
        angle = atan(fabs(newEndPont.x / newEndPont.y * 1.0)) + M_PI + M_PI_2;
    }
    CGContextRotateCTM(context, angle);
    if (_path) {
        CGPathRelease(_path);
    }
    _path = CGPathCreateMutable();
    CGContextBeginPath(context);
    CGPathMoveToPoint(_path, NULL, length, 0);
    CGPathAddLineToPoint(_path, NULL, length - 10 * 0.25 - self.lineWidth * 2.5, -6 * 0.25 - self.lineWidth * 0.6 * 2.5);
    CGPathAddLineToPoint(_path, NULL,length - 9 * 0.25 - self.lineWidth * 0.9 * 2.5, -3 * 0.25 - self.lineWidth * 0.3 * 2.5);
    CGPathAddLineToPoint(_path, NULL, 0, -2);
    CGPathAddLineToPoint(_path, NULL, 0, 2);
    CGPathAddLineToPoint(_path, NULL,length - 9 * 0.25 - self.lineWidth * 0.9 * 2.5, 3 * 0.25 + self.lineWidth * 0.3 * 2.5);
    CGPathAddLineToPoint(_path, NULL,length - 10 * 0.25 - self.lineWidth * 2.5, 6 * 0.25 + self.lineWidth * 0.6 * 2.5);
    CGPathCloseSubpath(_path);
    CGContextAddPath(context, _path);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
    
    if (self.selected) {
        CGContextAddPath(context, _path);
        CGContextSetStrokeColorWithColor(context, self.selectColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, self.selectLineWidth);//线的宽度
        CGContextStrokePath(context);
    }

    
    
}

- (bool)hitTest:(struct CGPoint)arg1
{
    CGPoint point = CGPointMake(arg1.x - _startPoint.x, arg1.y - _startPoint.y);
    CGFloat r = sqrt( pow(fabs(point.x), 2) + pow(fabs(point.y), 2) );
    CGPoint newEndPont = CGPointMake(_endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    CGFloat length = sqrt( pow(fabs(newEndPont.x), 2) + pow(fabs(newEndPont.y), 2) );
    if (length < 10) {
        return NO;
    }
    
    CGFloat angle = 0.0;
    if (point.x > 0 && point.y >= 0) {
        angle = atan(fabs(point.y / point.x * 1.0));
    }else if (point.x <= 0 && point.y > 0){
        angle = atan(fabs(point.x / point.y * 1.0)) + M_PI_2;
    }else if (point.x < 0 && point.y <= 0){
        angle = atan(fabs(point.y / point.x * 1.0)) + M_PI;
    }else if (point.x >= 0 && point.y < 0){
        angle = atan(fabs(point.x / point.y * 1.0)) + M_PI + M_PI_2;
    }
    if (newEndPont.x > 0 && newEndPont.y >= 0) {
        angle -= atan(fabs(newEndPont.y / newEndPont.x * 1.0));
    }else if (newEndPont.x <= 0 && newEndPont.y > 0){
        angle -= atan(fabs(newEndPont.x / newEndPont.y * 1.0)) + M_PI_2;
    }else if (newEndPont.x < 0 && newEndPont.y <= 0){
        angle -= atan(fabs(newEndPont.y / newEndPont.x * 1.0)) + M_PI;
    }else if (newEndPont.x >= 0 && newEndPont.y < 0){
        angle -= atan(fabs(newEndPont.x / newEndPont.y * 1.0)) + M_PI + M_PI_2;
    }
    
    CGPoint translatePoint = CGPointMake(cos(angle) * r,sin(angle) * r);
    
    bool ret = CGPathContainsPoint(_path, NULL, translatePoint, NO);
    if (ret) {
        NSLog(@"命中");
    }else{
        NSLog(@"没命中");
    }
    return  CGPathContainsPoint(_path, NULL, translatePoint, NO);
}

- (void)drawContentHandle:(struct CGContext *)context
{
    CGContextTranslateCTM(context, _startPoint.x, _startPoint.y);
    
    CGPoint newEndPont = CGPointMake(_endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    CGFloat length = sqrt( pow(fabs(newEndPont.x), 2) + pow(fabs(newEndPont.y), 2) );
    if (length < 10) {
        return;
    }
    CGFloat angle = 0.0;
    if (newEndPont.x > 0 && newEndPont.y >= 0) {
        angle = atan(fabs(newEndPont.y / newEndPont.x * 1.0));
    }else if (newEndPont.x <= 0 && newEndPont.y > 0){
        angle = atan(fabs(newEndPont.x / newEndPont.y * 1.0)) + M_PI_2;
    }else if (newEndPont.x < 0 && newEndPont.y <= 0){
        angle = atan(fabs(newEndPont.y / newEndPont.x * 1.0)) + M_PI;
    }else if (newEndPont.x >= 0 && newEndPont.y < 0){
        angle = atan(fabs(newEndPont.x / newEndPont.y * 1.0)) + M_PI + M_PI_2;
    }
    CGContextRotateCTM(context, angle);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度

    CGContextAddPath(context, _path);
    CGContextStrokePath(context);
    
}
- (BOOL)isValidFeatrue
{
    CGPoint newEndPont = CGPointMake(_endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    CGFloat length = sqrt( pow(fabs(newEndPont.x), 2) + pow(fabs(newEndPont.y), 2) );
    if (length < 10) {
        return NO;
    }
    return YES;
}
- (CGPoint)returnStartPoint
{
    return _startPoint;
}
- (CGPoint)returnEndPoint
{
    return _endPoint;
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
@end
