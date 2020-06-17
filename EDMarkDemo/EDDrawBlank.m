//
//  EDDrawBlank.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawBlank.h"

@implementation EDDrawBlank






- (void)drawContent:(struct CGContext *)context
{
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, _rect);
    CGContextFillPath(context);
}
@end
