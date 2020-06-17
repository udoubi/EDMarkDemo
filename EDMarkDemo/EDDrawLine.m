//
//  EDDrawLine.m
//  EDMarkDemo
//
//  Created by ke on 2020/5/26.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawLine.h"



@interface EDDrawLine()

@property (nonatomic,strong) NSMutableArray *pointArray;


@end


@implementation EDDrawLine



- (id)initWithStartPoint:(struct CGPoint)arg1
{
    if (self = [super initWithStartPoint:arg1]) {
        _startPoint = arg1;
        self.pointArray = [NSMutableArray array];
        [self.pointArray addObject:@(_startPoint)];
        _path = CGPathCreateMutable();
    }
    return self;
}


- (void)drawMove:(struct CGPoint)arg1
{
    [self.pointArray addObject:@(arg1)];
}


- (void)drawUp:(struct CGPoint)arg1
{
    [self.pointArray addObject:@(arg1)];
}

- (void)drawContent:(struct CGContext *)context
{
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    if (self.pointArray.count < 2) {
        return;
    }
    if (_path) {
        CGPathRelease(_path);
    }
    _path = CGPathCreateMutable();

    [self.pointArray enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [pointValue CGPointValue];
        if (idx == 0) {
            CGPathMoveToPoint(_path, NULL, point.x, point.y);
        }else{
            
            CGPoint prePoint = [self.pointArray[idx - 1] CGPointValue];
            CGPoint currentPoint = point;
            CGPoint midPoint = CGPointMake((prePoint.x + currentPoint.x) * 0.5, (prePoint.y + currentPoint.y) * 0.5);
            CGPathAddQuadCurveToPoint(_path, NULL, midPoint.x, midPoint.y, currentPoint.x, currentPoint.y);
        }
        
    }];
    CGContextSetLineCap(context, kCGLineCapRound);
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
    __block CGPoint firstPoint;
    __block BOOL isValidFeatrue = NO;
    [self.pointArray enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            firstPoint = [pointValue CGPointValue];
        }else{
            CGPoint point = [pointValue CGPointValue];
            if (!CGPointEqualToPoint(firstPoint, point)) {
                isValidFeatrue = YES;
            }
        }
    }];
    return isValidFeatrue;
}
- (bool)hitTest:(struct CGPoint)arg1
{
    if (self.pointArray.count < 2) {
        return NO;
    }
    __block BOOL contain = NO;
    [self.pointArray enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [pointValue CGPointValue];
        if (idx == 0) {
            
        }else{
            CGMutablePathRef path = CGPathCreateMutable();
            CGPoint prePoint = [self.pointArray[idx - 1] CGPointValue];
            CGPathAddRect(path, NULL, CGRectMake(prePoint.x, prePoint.y, point.x - prePoint.x, point.y - prePoint.y));
            if (CGPathContainsPoint(path, NULL, arg1, NO)) {
                contain = YES;
                *stop = YES;
            }
            CGPathRelease(path);
        }
    }];
    return  contain;
}
- (void)moveByOffset:(struct CGSize)offset endPoint:(struct CGPoint)arg2
{
    
    NSMutableArray *retArray = [NSMutableArray array];
    [self.pointArray enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [pointValue CGPointValue];
        point.x += offset.width;
        point.y += offset.height;
        [retArray addObject:@(point)];
    }];
    self.pointArray = retArray;
}

- (BOOL)canMoveEnded
{
    return NO;
}
- (NSArray *)getToolKeyPoints
{
    
    NSArray *points = self.pointArray;
    
    return points;

}
@end
