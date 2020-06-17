//
//  EDDrawView.m
//  Test
//
//  Created by ke on 2020/5/25.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawView.h"
#import "EDDrawLine.h"
#import "EDDrawRect.h"
#import "EDDrawArrow.h"
#import "YYKit.h"
#import "EDDrawTextView.h"
#import "EDDrawText.h"
#import "EDDrawBlank.h"
#import <UIImage+YYAdd.h>
#import "EDDrawDotButton.h"
#import "EDDrawViewConstant.h"

typedef NS_ENUM(NSUInteger, EDDrawViewDrawState) {
    EDDrawViewDrawState_Default,
    EDDrawViewDrawState_Drawing,
    EDDrawViewDrawState_DrawingText,
    EDDrawViewDrawState_Handle,
    EDDrawViewDrawState_Editing,
    EDDrawViewDrawState_Move,
};


@interface EDDrawView()<YYTextViewDelegate>
{
    Class _toolClass;
    
}

@property (nonatomic,assign) CGFloat scale;
@property (nonatomic,assign) CGPoint transformPoint;


@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;



@property (nonatomic,strong) EDDrawTool *handingTool;
@property (nonatomic,strong) EDDrawTextView *textView;
@property (nonatomic,assign) EDDrawViewDrawState drawState;

@property (nonatomic,assign) CGPoint moveStartPoint;

@property (nonatomic,assign) CGRect imageRect;


@property (nonatomic,assign) CGFloat angel;
@property (nonatomic,strong) UIView *controlDot;
@property (nonatomic,strong) UIImage *editImage;



@end


@implementation EDDrawView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
  
        self.backgroundColor = [UIColor blackColor];
        self.toolArray = [NSMutableArray array];
        _toolClass = [EDDrawArrow class];
        [self addGesture];

    }
    return self;
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    CGRect rect;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    if (image.size.width / width > image.size.height / height) {

        CGFloat scale = image.size.width / width;
        CGFloat markHeight =  image.size.height / scale;
        CGFloat y = (height - markHeight) / 2;

        rect = CGRectMake(0, y, width, markHeight);
    }else{

        CGFloat scale = image.size.height / height;
        CGFloat markWidth =  image.size.width / scale;
        CGFloat x = (width - markWidth) / 2;

        rect = CGRectMake(x, 0, markWidth, height);
    }
    _imageRect = rect;
    
}
- (void)addTool:(EDDrawTool *)tool
{
    [[self.undoManager prepareWithInvocationTarget:self] removeTool:tool];//逆向删除
    [self.toolArray addObject:tool];
    [self caculateShouldExpandImage];
    [self setNeedsDisplay];
}
- (void)removeTool:(EDDrawTool *)tool
{
    [[self.undoManager prepareWithInvocationTarget:self] addTool:tool];//逆向删除
    [self.toolArray removeObject:tool];
    [self caculateShouldExpandImage];
    [self setNeedsDisplay];
}
- (void)addGesture
{
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.minimumNumberOfTouches = 2;
    [self addGestureRecognizer:panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
}

- (void)drawRect:(CGRect)mrect {

    CGContextRef context = UIGraphicsGetCurrentContext();

//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextTranslateCTM(context, 0, -mrect.size.height);


    
//    CGRect rect;
//    CGFloat width = CGRectGetWidth(mrect);
//    CGFloat height = CGRectGetHeight(mrect);
//    if (self.image.size.width / width > self.image.size.height / height) {
//
//        CGFloat scale = self.image.size.width / width;
//        CGFloat markHeight =  self.image.size.height / scale;
//        CGFloat y = (height - markHeight) / 2;
//
//        rect = CGRectMake(0, y, width, markHeight);
//    }else{
//
//        CGFloat scale = self.image.size.height / height;
//        CGFloat markWidth =  self.image.size.width / scale;
//        CGFloat x = (width - markWidth) / 2;
//
//        rect = CGRectMake(x, 0, markWidth, height);
//    }
//
//    _imageRect = rect;
    
//    [self.editImage drawInRect:_imageRect];
//    CGContextDrawImage(context, rect, self.image.CGImage);
    

//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
//    CGContextSetLineWidth(context, 3.0);//线的宽度
//    CGContextAddRect(context,CGRectMake(0, 0, mrect.size.width, mrect.size.height));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径

//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);//线框颜色
//    CGContextAddRect(context,CGRectMake(mrect.size.width - 10, mrect.size.height - 10, 10, 10));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
    

//    if (self.scale > 0) {
//        CGContextTranslateCTM(context, mrect.size.width * (1- self.scale) * 0.5 , mrect.size.height * (1- self.scale) * 0.5);
//        CGContextScaleCTM(context, self.scale,self.scale);
//    }
//
//    if (!CGPointEqualToPoint(self.transformPoint, CGPointZero)) {
//
//        CGContextTranslateCTM(context,self.transformPoint.x , -self.transformPoint.y);
//    }
    
    
//    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);//填充颜色
//    CGContextAddRect(context,CGRectMake(0, 0, 10, 10));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
//
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);//线框颜色
//    CGContextAddRect(context,CGRectMake(mrect.size.width - 10, mrect.size.height - 10, 10, 10));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
//
    
//    CGContextDrawImage(context, rect, self.image.CGImage);
    
    
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);//填充颜色
//    CGContextSetLineWidth(context, 3.0);//线的宽度
//    CGContextAddRect(context,CGRectMake(mrect.size.width / 2 , mrect.size.height / 2, 200, 300));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
    
    
    

    
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextTranslateCTM(context, 0, -mrect.size.height);

    [self.blankDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, EDDrawBlank *blank, BOOL * _Nonnull stop) {
        CGContextSaveGState(context);
        [blank drawContent:context];
        CGContextRestoreGState(context);
    }];
    
    [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
        CGContextSaveGState(context);
        [tool drawContent:context];
        CGContextRestoreGState(context);
    }];
    if (self.handingTool) {
        [self.handingTool drawContent:context];
    }

 
    [super drawRect:mrect];
    
}


- (void)updateDrawView
{
    CGAffineTransform move =  CGAffineTransformMakeTranslation(self.transformPoint.x, self.transformPoint.y);
    CGAffineTransform scale =  CGAffineTransformMakeScale(self.scale, self.scale);
    CGAffineTransform transform = CGAffineTransformConcat(move, scale);
    [self.layer setAffineTransform:transform];
    if ([self.delegate respondsToSelector:@selector(didDrawTransformUpdate:)]) {
        [self.delegate didDrawTransformUpdate:transform];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [gesture setTranslation:self.transformPoint inView:self];
    }else if (gesture.state==UIGestureRecognizerStateChanged){
        CGPoint transP = [gesture translationInView:self];
        NSLog(@"偏移：%@",NSStringFromCGPoint(transP));
        
        CGFloat maxXOffset = self.bounds.size.width * (self.scale - 1) * 0.25;
        CGFloat maxYOffset = -self.bounds.size.height * (self.scale - 1) * 0.25;
        if (transP.x > maxXOffset) {
            transP.x = maxXOffset;
        }
        if (transP.x < -maxXOffset) {
            transP.x = -maxXOffset;
        }
        if (transP.y < maxYOffset) {
            transP.y = maxYOffset;
        }
        if (transP.y > -maxYOffset) {
            transP.y = -maxYOffset;
        }
        
        self.transformPoint = transP;
        [self updateDrawView];
    }else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        
        NSLog(@"%@,%@",NSStringFromSelector(_cmd),NSStringFromCGPoint(self.transformPoint));
        NSLog(@"%@,%@",NSStringFromSelector(_cmd),NSStringFromCGPoint(self.center));
    }
}
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.scale < 1.0) {
            self.scale = 1.0;
        }
        gesture.scale = self.scale;
    }else if (gesture.state==UIGestureRecognizerStateChanged){
        self.scale = gesture.scale;
        if (self.scale < 1.0) {
            self.scale = 1.0;
        }else if(self.scale > 2.0){
            self.scale = 2.0;
        }
        NSLog(@"缩放：%f",self.scale);
        [self updateDrawView];
    }else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint transP = self.transformPoint;
        CGFloat maxXOffset = self.bounds.size.width * (self.scale - 1) * 0.25;
        CGFloat maxYOffset = -self.bounds.size.height * (self.scale - 1) * 0.25;
        if (transP.x > maxXOffset) {
            transP.x = maxXOffset;
        }
        if (transP.x < -maxXOffset) {
            transP.x = -maxXOffset;
        }
        if (transP.y < maxYOffset) {
            transP.y = maxYOffset;
        }
        if (transP.y > -maxYOffset) {
            transP.y = -maxYOffset;
        }
        
        self.transformPoint = transP;
        [self updateDrawView];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [super touchesBegan:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    self.startPoint = touchPoint;
    
    if ([touch.view isEqual:self.controlDot]) {
        
        __block EDDrawTool *selectTool = nil;
        [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tool.selected) {
                selectTool = tool;
                *stop = YES;
            }
        }];
        
        self.handingTool = selectTool;
        self.moveStartPoint = touchPoint;
        _drawState = EDDrawViewDrawState_Editing;
        return;
    }
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),NSStringFromCGPoint(touchPoint));
    
    __block BOOL needDispaly = NO;
    if (_textView.text.length > 0) {
        
        if ([self.handingTool isKindOfClass:[EDDrawText class]]) {
            EDDrawText *tool = (EDDrawText *)self.handingTool;
            tool.content = _textView.text;
            CGRect rect = [_textView textBoundingRect];
            tool.textBoundingSize = rect.size;
//            [self.toolArray addObject:self.handingTool];
            [self addTool:self.handingTool];
            
            needDispaly = YES;
        }
    }
    if (_textView) {
        [_textView removeFromSuperview];
        _textView = nil;
        self.handingTool = nil;
    }


    NSArray *retArray =  [[self.toolArray reverseObjectEnumerator] allObjects];
    __block EDDrawTool *selectTool = nil;
    [retArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([tool hitTest:touchPoint]) {
            _drawState = EDDrawViewDrawState_Handle;
            selectTool = tool;
            *stop = YES;
        }
    }];
    //有图形被选中
    if (selectTool) {
        
        __block BOOL isSame = NO;
        [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tool.selected && [tool isEqual:selectTool]) {
                isSame = YES;
                *stop = YES;
            }
            tool.selected = NO;
        }];
        selectTool.selected = YES;
        if ([self.delegate respondsToSelector:@selector(didDrawViewStartHandingTool:)]) {
            [self.delegate didDrawViewStartHandingTool:self];
        }
        if ([selectTool canMoveEnded]) {
            CGPoint endPoint = [selectTool getEndPoint];
            self.controlDot.frame = CGRectMake(endPoint.x - 7, endPoint.y - 7, 14, 14);
            [self addSubview:self.controlDot];
        }
        if (isSame) {
            
        }else{
            
            needDispaly = YES;
        }
        self.moveStartPoint = touchPoint;
    }else{
        //点击了画布
        [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tool.selected) {
                tool.selected = NO;
                needDispaly = YES;
            }
        }];
        if (_drawState == EDDrawViewDrawState_Handle) {
            [self.controlDot removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(didDrawViewEndHandingTool:)]) {
                [self.delegate didDrawViewEndHandingTool:self];
            }
        }
        _drawState = EDDrawViewDrawState_Default;
    }
    if (needDispaly) {
        [self setNeedsDisplay];
        return;
    }

    if (_drawState == EDDrawViewDrawState_Default) {
        if (_drawType == EDDrawViewToolType_Text) {
            
            if (touchPoint.x + 62 > CGRectGetWidth(self.frame) || touchPoint.y + 27 > CGRectGetHeight(self.frame)) {
                return;
            }
            
            _textView = [self defualtTextView];
            _textView.frame = CGRectMake(touchPoint.x, touchPoint.y, CGRectGetWidth(self.frame) - touchPoint.x, CGRectGetHeight(self.frame) - touchPoint.y);
            [self addSubview:_textView];
            [_textView becomeFirstResponder];
        }
        self.handingTool = [[_toolClass alloc] initWithStartPoint:touchPoint];
        self.handingTool.color = self.lineColor;
        self.handingTool.lineWidth = self.lineWidth;
        self.handingTool.fontSize = self.fontSize;
        self.handingTool.selectColor = self.selectLineColor;
        self.handingTool.selectLineWidth = self.selectLineWidth;
    }else if(_drawState == EDDrawViewDrawState_Handle){
        
        self.handingTool = selectTool;
        self.moveStartPoint = touchPoint;
    }
    

}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.handingTool == nil) {
        return;
    }
    
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),NSStringFromCGPoint(touchPoint));
    
    if (_drawState == EDDrawViewDrawState_Default) {
        if (_drawType == EDDrawViewToolType_Arrow ||
            _drawType == EDDrawViewToolType_Rect ||
            _drawType == EDDrawViewToolType_Line) {
            
            [self.handingTool drawMove:touchPoint];
            
            [self setNeedsDisplay];
            if (!CGPointEqualToPoint(self.startPoint, touchPoint)) {
                if ([self.delegate respondsToSelector:@selector(didDrawViewOnDrawing:)]) {
                    [self.delegate didDrawViewOnDrawing:self];
                }
            }
        }
    }else if(_drawState == EDDrawViewDrawState_Handle){
        
        CGSize offset = CGSizeMake(touchPoint.x - self.moveStartPoint.x, touchPoint.y - self.moveStartPoint.y);
        
        [self.handingTool moveByOffset:offset endPoint:touchPoint];
        [self setNeedsDisplay];
        self.moveStartPoint = touchPoint;
        
        if ([self.handingTool canMoveEnded]) {
            CGPoint point = [self.handingTool getEndPoint];
            self.controlDot.center = point;
        }
        if (!CGPointEqualToPoint(self.startPoint, touchPoint)) {
            if ([self.delegate respondsToSelector:@selector(didDrawViewOnDrawing:)]) {
                [self.delegate didDrawViewOnDrawing:self];
            }
        }

    }else if(_drawState == EDDrawViewDrawState_Editing){
        
        CGSize offset = CGSizeMake(touchPoint.x - self.moveStartPoint.x, touchPoint.y - self.moveStartPoint.y);

        [self.handingTool moveEndedWithOffset:offset];
        self.controlDot.center = CGPointMake(CGRectGetMidX(self.controlDot.frame) + offset.width, CGRectGetMidY(self.controlDot.frame) + offset.height);
        [self setNeedsDisplay];
        self.moveStartPoint = touchPoint;
        if (!CGPointEqualToPoint(self.startPoint, touchPoint)) {
            if ([self.delegate respondsToSelector:@selector(didDrawViewOnDrawing:)]) {
                [self.delegate didDrawViewOnDrawing:self];
            }
        }
    }


}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.handingTool == nil) {
        return;
    }
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"%@,%@",NSStringFromSelector(_cmd),NSStringFromCGPoint(touchPoint));
    
    

    if (_drawState == EDDrawViewDrawState_Default) {
        if (_drawType == EDDrawViewToolType_Arrow ||
            _drawType == EDDrawViewToolType_Rect ||
            _drawType == EDDrawViewToolType_Line) {

            [self.handingTool drawUp:touchPoint];
            if ([self.handingTool isValidFeatrue]) {
//                [self.toolArray addObject:self.handingTool];
                [self addTool:self.handingTool];
            }
//            [self caculateShouldExpandImage];
            [self setNeedsDisplay];
            self.handingTool = nil;
            
            if ([self.delegate respondsToSelector:@selector(didDrawViewEndDrawing:)]) {
                [self.delegate didDrawViewEndDrawing:self];
            }
            
        }
    }else if(_drawState == EDDrawViewDrawState_Handle){
        
        CGSize offset = CGSizeMake(touchPoint.x - self.moveStartPoint.x, touchPoint.y - self.moveStartPoint.y);
        
        [self.handingTool moveByOffset:offset endPoint:touchPoint];
        [self caculateShouldExpandImage];
        [self setNeedsDisplay];
        
        if ([self.handingTool canMoveEnded]) {
            CGPoint point = [self.handingTool getEndPoint];
            self.controlDot.center = point;
        }
        
        self.handingTool = nil;
        
        if ([self.delegate respondsToSelector:@selector(didDrawViewEndDrawing:)]) {
            [self.delegate didDrawViewEndDrawing:self];
        }
        
    }else if(_drawState == EDDrawViewDrawState_Editing){
            
        CGSize offset = CGSizeMake(touchPoint.x - self.moveStartPoint.x, touchPoint.y - self.moveStartPoint.y);

        [self.handingTool moveEndedWithOffset:offset];
        self.controlDot.center = CGPointMake(CGRectGetMidX(self.controlDot.frame) + offset.width, CGRectGetMidY(self.controlDot.frame) + offset.height);
        [self caculateShouldExpandImage];
        [self setNeedsDisplay];
        self.handingTool = nil;
        _drawState = EDDrawViewDrawState_Handle;
        
        if ([self.delegate respondsToSelector:@selector(didDrawViewEndDrawing:)]) {
            [self.delegate didDrawViewEndDrawing:self];
        }
    }

}

- (void)setDrawType:(EDDrawViewToolType)drawType
{
    _drawType = drawType;
    if (drawType == EDDrawViewToolType_Arrow) {
        _toolClass = [EDDrawArrow class];
    }else if (drawType == EDDrawViewToolType_Rect){
        _toolClass = [EDDrawRect class];
    }else if (drawType == EDDrawViewToolType_Line){
        _toolClass = [EDDrawLine class];
    }else if (drawType == EDDrawViewToolType_Text){
        _toolClass = [EDDrawText class];
    }else if (drawType == EDDrawViewToolType_Rotate){
        
        self.angel += M_PI_2;
        [self setNeedsDisplay];
    }else if (drawType == EDDrawViewToolType_Cut){
        _toolClass = [EDDrawArrow class];
    }else if (drawType == 4){
        [self.toolArray removeAllObjects];
        self.handingTool = nil;
        [self setNeedsDisplay];
    }else if (drawType == 3){

        
    }
}
- (EDDrawTextView *)defualtTextView
{
    EDDrawTextView *textView = [[EDDrawTextView alloc] init];
    textView.scrollEnabled = NO;
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = self.fontSize;
    textView.textColor = self.lineColor;
    return textView;
}
- (void)textViewDidChange:(EDDrawTextView *)textView
{
    [self.textView setNeedsDisplay];
}
- (CGRect)getExportImageRect
{
      
      CGRect  cutRect = _imageRect;
      if (CGRectGetWidth(self.frame) / CGRectGetHeight(self.frame) > CGRectGetWidth(_imageRect) / CGRectGetHeight(_imageRect)) {
          
          EDDrawBlank *blank = [self.blankDictionary objectForKey:@"Left"];
          if (blank) {
              cutRect = CGRectMake(CGRectGetMinX(blank.rect), cutRect.origin.y, cutRect.size.width + CGRectGetWidth(blank.rect), cutRect.size.height);
          }
          blank = [self.blankDictionary objectForKey:@"Right"];
          if (blank) {
              cutRect = CGRectMake(cutRect.origin.x, cutRect.origin.y, cutRect.size.width + CGRectGetWidth(blank.rect), cutRect.size.height);
          }
      }else{
          EDDrawBlank *blank = [self.blankDictionary objectForKey:@"Top"];
          if (blank) {
              cutRect = CGRectMake(cutRect.origin.x, CGRectGetMinY(blank.rect), cutRect.size.width, cutRect.size.height + CGRectGetHeight(blank.rect));
          }
          blank = [self.blankDictionary objectForKey:@"Bottom"];
          if (blank) {
              cutRect = CGRectMake(cutRect.origin.x, cutRect.origin.y, cutRect.size.width, cutRect.size.height + CGRectGetHeight(blank.rect));
          }
      }
      
      return cutRect;
 
}
- (void)caculateShouldExpandImage
{
    
    CGRect rect = _imageRect;
    
    __block CGPoint topMaxPoint = CGPointMake(0, CGRectGetMinY(rect));
    __block CGPoint bottomMaxPoint = CGPointMake(0, CGRectGetMaxY(rect));
    __block CGPoint leftMaxPoint = CGPointMake(CGRectGetMinX(rect), 0);
    __block CGPoint rightMaxPoint = CGPointMake(CGRectGetMaxX(rect), 0);
    
    self.blankDictionary = [NSMutableDictionary dictionary];
    
    [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *points = [tool getToolKeyPoints];
        //不会存在点同时超过2条边界
        [points enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGPoint p = [pointValue CGPointValue];
            
            if (p.x >= CGRectGetMinX(rect) && p.x <= CGRectGetMaxX(rect) && p.y >= CGRectGetMinY(rect) && p.y <= CGRectGetMaxY(rect)) {
                
                NSLog(@"在边界里面");
            }else{

                if (p.x  < CGRectGetMinX(rect) && p.x < leftMaxPoint.x) {
                    leftMaxPoint = p;
                }else if (p.y  < CGRectGetMinY(rect) && p.y < topMaxPoint.y) {
                    topMaxPoint = p;
                }else if (p.x  > CGRectGetMaxX(rect) && p.x > rightMaxPoint.x) {
                    rightMaxPoint = p;
                }else if (p.y  > CGRectGetMaxY(rect) && p.y > bottomMaxPoint.y) {
                    bottomMaxPoint = p;
                }
                
            }
        }];
        //上下扩展或者左右扩展
        if (CGRectGetWidth(self.frame) / CGRectGetHeight(self.frame) > CGRectGetWidth(_imageRect) / CGRectGetHeight(_imageRect)) {
            if (!CGPointEqualToPoint(leftMaxPoint, CGPointMake(CGRectGetMinX(rect), 0) )) {
                EDDrawBlank *blank = [EDDrawBlank new];
                blank.rect = CGRectMake(leftMaxPoint.x, 0, CGRectGetMinX(rect) - leftMaxPoint.x, CGRectGetHeight(self.frame));
                [self.blankDictionary setObject:blank forKey:@"Left"];
                
            }
            if (!CGPointEqualToPoint(rightMaxPoint, CGPointMake(CGRectGetMaxX(rect), 0) )) {
                EDDrawBlank *blank = [EDDrawBlank new];
                blank.rect = CGRectMake(CGRectGetMaxX(rect), 0, rightMaxPoint.x - CGRectGetMaxX(rect), CGRectGetHeight(self.frame));
                [self.blankDictionary setObject:blank forKey:@"Right"];
            }
        }else{
            if (!CGPointEqualToPoint(topMaxPoint, CGPointMake(0, CGRectGetMinY(rect)) )) {
                EDDrawBlank *blank = [EDDrawBlank new];
                blank.rect = CGRectMake(0, topMaxPoint.y, CGRectGetWidth(self.frame), CGRectGetMinY(rect) - topMaxPoint.y);
                [self.blankDictionary setObject:blank forKey:@"Top"];
            }
            if (!CGPointEqualToPoint(bottomMaxPoint, CGPointMake(0, CGRectGetMaxY(rect)) )) {
                EDDrawBlank *blank = [EDDrawBlank new];
                blank.rect = CGRectMake(0, CGRectGetMaxY(rect), CGRectGetHeight(self.frame),bottomMaxPoint.y - CGRectGetMaxY(rect));
                [self.blankDictionary setObject:blank forKey:@"Bottom"];
            }
        }
    }];

    
}
- (void)actionClearCanvas
{
    [self.toolArray removeAllObjects];
    self.handingTool = nil;
    [self.controlDot removeFromSuperview];
    [self caculateShouldExpandImage];
    [self setNeedsDisplay];
}
- (void)actionDeleteCurrentTool
{
    [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (tool.selected) {
            [self.toolArray removeObject:tool];
            self.handingTool = nil;
            [self caculateShouldExpandImage];
            [self setNeedsDisplay];
            *stop = YES;
        }
    }];
    [self.controlDot removeFromSuperview];
}


- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;

    [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
        if (tool.selected) {
            
            tool.lineWidth = lineWidth;
            [self setNeedsDisplay];
            *stop = YES;
        }
    }];
}
- (void)setFontSize:(UIFont *)fontSize
{
    _fontSize = fontSize;
    if (_drawState == EDDrawViewDrawState_Handle) {

        [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tool isKindOfClass:EDDrawText.class] && tool.selected) {
                EDDrawText *drawText = (EDDrawText *)tool;
                drawText.fontSize = fontSize;
                CGPoint point = [drawText getStartPoint];
                EDDrawTextView *textView = [self defualtTextView];
                textView.font = fontSize;
                textView.text = drawText.content;
                textView.frame = CGRectMake(point.x, point.y, CGRectGetWidth(self.frame) - point.x, CGRectGetHeight(self.frame) - point.y);
                CGRect rect = [textView textBoundingRect];
                drawText.textBoundingSize = rect.size;
                [self setNeedsDisplay];
                
                *stop = YES;
            }
        }];
    }
}
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    if (_drawState == EDDrawViewDrawState_Handle) {
        [self.toolArray enumerateObjectsUsingBlock:^(EDDrawTool *tool, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tool.selected) {
                
                tool.color = lineColor;
                [self setNeedsDisplay];
                *stop = YES;
            }
        }];
    }
}
- (UIView *)controlDot
{
    if (_controlDot == nil) {
        _controlDot = [UIView new];
        _controlDot.userInteractionEnabled = YES;
        _controlDot.backgroundColor = [UIColor colorWithHex:0x4991E1];
        _controlDot.layer.cornerRadius = 7;
        _controlDot.layer.borderWidth = 2;
        _controlDot.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _controlDot;
}
@end
