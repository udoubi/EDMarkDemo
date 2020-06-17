//
//  EDDrawTool.h
//  EDMarkDemo
//
//  Created by ke on 2020/5/26.
//  Copyright © 2020 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EDDrawTool : NSObject
{
    _Bool _finalized;
    _Bool _selected;
    struct CGPoint _startPoint;
    struct CGPoint _endPoint;
    double _unitScale;
    UIColor *_handleFillColor;
    long long _handleSize;
    long long _handleLineWidthSize;
    unsigned long long _drawType;
    double _rotateAngle;
    double _lastRotateAngle;
    struct CGAffineTransform _mInvertTransform;
    struct CGAffineTransform _transform;
    unsigned long long _moveDirection;
    NSString *_unit;
    _Bool showMeasurement;
    _Bool _isNewBuild;
    _Bool _isMutableTool;
    NSString *_name;
    double _lineWidth;
    UIColor *_color;
    double calibration;
    NSString *measureText;
    UIColor *fillColor;
    double zoomScale;
    double _handleViewScale;
    struct CGPoint preScalePoint;
    struct CGPoint centerPoint;
    CGMutablePathRef _path;
}
@property(nonatomic) double handleViewScale;
@property(nonatomic) double zoomScale;
@property(nonatomic) struct CGPoint preScalePoint;
@property(nonatomic) struct CGPoint centerPoint;
@property(retain, nonatomic) UIColor *fillColor;
@property(nonatomic) double rotateAngle;
@property(retain, nonatomic) UIColor *color;
@property(nonatomic) double lineWidth;
@property(retain, nonatomic) UIFont *fontSize;
@property(retain, nonatomic) UIColor *selectColor;
@property(nonatomic) double selectLineWidth;
@property(readonly, nonatomic) struct CGRect frameIncludeLineWidth;
@property(nonatomic) _Bool selected;
@property(nonatomic) _Bool isMutableTool;
@property(nonatomic) _Bool isNewBuild;


- (void)drawContentHandle:(struct CGContext *)arg1;
- (void)drawSlectedStateContent:(struct CGContext *)arg1;
- (void)drawContent:(struct CGContext *)arg1;
- (void)draw:(struct CGContext *)arg1;
- (void)limitValidFeatrue;
- (void)stopMoveHandle;
- (_Bool)isRotateByRotateCtx;
- (_Bool)isSupportGestureRotate;
- (struct CGPoint)transformPoint:(struct CGPoint)arg1;
- (struct CGPoint)invertPoint:(struct CGPoint)arg1;
- (void)rotateEndedWithAngle:(double)arg1;
- (void)rotateChangedWithAngle:(double)arg1;
- (void)moveByOffset:(struct CGSize)arg1 endPoint:(struct CGPoint)arg2;
- (void)tryMovePoint:(struct CGPoint)arg1 endPoint:(struct CGPoint)arg2;
- (_Bool)testHitOnHandle:(struct CGPoint)arg1;
- (_Bool)hitOnHandle:(struct CGPoint)arg1;
- (_Bool)hitTest:(struct CGPoint)arg1;
- (void)drawUp:(struct CGPoint)arg1;
- (void)drawMove:(struct CGPoint)arg1;
- (void)drawDown:(struct CGPoint)arg1;
- (BOOL)isValidFeatrue;
- (CGPoint)returnStartPoint;
- (CGPoint)returnEndPoint;
- (id)initWithStartPoint:(struct CGPoint)arg1;

- (NSArray *)getToolKeyPoints;
- (CGPoint)getEndPoint;

- (void)moveEndedWithOffset:(CGSize)offset;
- (BOOL)canMoveEnded;

@end




NS_ASSUME_NONNULL_END
