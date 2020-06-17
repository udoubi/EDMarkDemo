//
//  EDDrawTool.m
//  EDMarkDemo
//
//  Created by ke on 2020/5/26.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawTool.h"

@implementation EDDrawTool

- (id)initWithStartPoint:(struct CGPoint)arg1
{
    if (self = [super init]) {
        _startPoint = arg1;
        
    }
    return self;
}

- (CGPoint)returnStartPoint
{
    return CGPointZero;
}
- (CGPoint)returnEndPoint
{
    return CGPointZero;
}

- (NSArray *)getToolKeyPoints
{
    
    NSArray *points = @[@(_startPoint),@(_endPoint)];
    
    return points;

}

- (CGPoint)getEndPoint
{
    return _endPoint;
}

@end
