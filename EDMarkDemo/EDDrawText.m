//
//  EDDrawText.m
//  EDMarkDemo
//
//  Created by ke on 2020/5/27.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawText.h"
#import <CoreText/CoreText.h>
#import <YYKit/YYKit.h>

@implementation EDDrawText

- (void)drawMove:(struct CGPoint)arg1
{
    
}
- (void)drawUp:(struct CGPoint)arg1
{
    
}
- (void)drawContent:(struct CGContext *)context
{
    
    CGRect rect =  CGRectMake(_startPoint.x, _startPoint.y, _textBoundingSize.width, _textBoundingSize.height);

    CGContextTranslateCTM(context, _startPoint.x, _startPoint.y);
    CGContextTranslateCTM(context, 0, _textBoundingSize.height);
    CGContextScaleCTM(context, 1, -1);
    
    
    CGContextSetShouldSmoothFonts(context, YES);

    _path = CGPathCreateMutable();
    CGPathAddRect(_path, NULL, (CGRect){CGPointMake(4, -6),rect.size});
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:_content attributes:@{NSForegroundColorAttributeName:self.color,NSFontAttributeName:self.fontSize}];

    {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:contentString];
        [attString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSStrokeColorAttributeName:[UIColor whiteColor],
                                   NSStrokeWidthAttributeName:@(20),
                                   
        } range:NSMakeRange(0, attString.length)];
        
        
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFTypeRef)attString);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), _path, NULL);
        CTFrameDraw(frame, context);
    }
    
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFTypeRef)contentString);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, contentString.length), _path, NULL);
        CTFrameDraw(frame, context);
    }
    
    if (self.selected) {
//        CGPathAddRect(_path, NULL, (CGRect){CGPointZero,rect.size});
        CGContextTranslateCTM(context, -4, 6);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddPath(context, _path);
        CGContextSetStrokeColorWithColor(context, self.selectColor.CGColor);//填充颜色
        CGContextSetLineWidth(context, self.selectLineWidth);//线的宽度
        CGContextStrokePath(context);
    }

}

- (bool)hitTest:(CGPoint)point
{
    CGPoint retPoint =  CGPointMake(point.x - _startPoint.x, point.y - _startPoint.y);
    
    
    return  CGPathContainsPoint(_path, NULL, retPoint, NO);
}

- (void)moveByOffset:(struct CGSize)offset endPoint:(struct CGPoint)arg2
{
    _startPoint.x += offset.width;
    _startPoint.y += offset.height;
    
}
- (void)moveEndedWithOffset:(CGSize)offset
{
    
    //竖向达到最小，那么只能缩小横向，加大竖向
    //横向达到最小，那么只能缩小竖向，加大竖向
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:_content attributes:@{NSForegroundColorAttributeName:self.color,NSFontAttributeName:self.fontSize}];
    CGSize vMinSize,hMinSize;
    {
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.fontSize.pointSize, CGFLOAT_MAX) insets:UIEdgeInsetsMake(6, 4, 6, 4)];
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:contentString];
        vMinSize = layout.textBoundingSize;
    }
    {
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX) insets:UIEdgeInsetsMake(6, 4, 6, 4)];
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:contentString];
        hMinSize = layout.textBoundingSize;
    }
    
    CGFloat width = _textBoundingSize.width + offset.width;
    CGFloat height = _textBoundingSize.height + offset.height;
    if (width > vMinSize.width && width < hMinSize.width)
    {
        _textBoundingSize.width = width;
        
    }

    
    if (height > hMinSize.height && height < vMinSize.height)
    {
        _textBoundingSize.height = height;
        
    }

    
    NSLog(@"竖向前:%@",NSStringFromCGSize(_textBoundingSize));
    YYTextContainer *container = [YYTextContainer containerWithSize:_textBoundingSize insets:UIEdgeInsetsMake(6, 4, 6, 4)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:contentString];
    NSLog(@"竖向：%@",NSStringFromCGSize(layout.textBoundingSize));

    
    
}
- (BOOL)canMoveEnded
{
    return YES;
}
- (NSArray *)getToolKeyPoints
{
    
    NSArray *points = @[@(_startPoint),@(CGPointMake(_startPoint.x + _textBoundingSize.width, _startPoint.y)),@(CGPointMake(_startPoint.x, _startPoint.y + _textBoundingSize.height)),@(CGPointMake(_startPoint.x + _textBoundingSize.width, _startPoint.y + _textBoundingSize.height)) ];

    return points;
}
- (CGPoint)getStartPoint
{
    return _startPoint;
}
- (CGPoint)getEndPoint
{
    return CGPointMake(_startPoint.x + _textBoundingSize.width, _startPoint.y + _textBoundingSize.height);
}
@end
