//
//  EDDrawCutView.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/5.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawCutView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Addition.h"
#import <YYKit/YYKit.h>

typedef NS_ENUM(NSInteger, EDDrawCutViewOperration)
{
    EDDrawCutViewOperrationMoveCenter = 0,
    EDDrawCutViewOperrationMoveLeftLine = 1 << 0,
    EDDrawCutViewOperrationMoveTopLine = 1 << 1,
    EDDrawCutViewOperrationMoveRightLine = 1 << 2,
    EDDrawCutViewOperrationMoveBottomLine = 1 << 3,
};
const NSInteger marginForLine = 40;
const NSInteger minWidthForCut = 80;
const NSInteger minHeightForCut = 80;
const NSInteger bottomViewHeight = 45;
const CGFloat imageViewScaleValue = 0.95;



@interface EDDrawCutView()

@property (nonatomic,strong) UIImage *editImage;
@property (nonatomic,strong) UIImageView *editImageView;
@property (strong,nonatomic) UIView * overView;
@property (nonatomic, strong)CAShapeLayer *cutShapeLayer;//裁剪框layer
@property (strong, nonatomic) UIView *squareView;
@property (nonatomic,assign) CGPoint panStartPoint;
@property (nonatomic,assign) CGPoint beforeOringalCenter;
@property (nonatomic,assign) CGRect beforeOringalFrame;
@property (nonatomic,assign) EDDrawCutViewOperration cutOperation;
@property (nonatomic,strong) NSMutableArray<UIView *> *lineArray;

@end

@implementation EDDrawCutView


- (instancetype)initWithEditImage:(UIImage *)editImage
{
    if (self = [super init]) {
        
        self.editImage = editImage;
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"ed_image_cut_sure"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(actionCancelCut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        restoreButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [restoreButton setTitle:@"还原" forState:UIControlStateNormal];
        restoreButton.enabled = NO;
        [restoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [restoreButton addTarget:self action:@selector(actionRestoreCut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:restoreButton];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setImage:[UIImage imageNamed:@"ed_image_cut_cancel"] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(actionSureCut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureButton];
        
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-17);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-17);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-10);
            make.bottom.equalTo(self).offset(-17);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        
        UIImageView *editImageView = [UIImageView new];
        editImageView.image = editImage;
        editImageView.userInteractionEnabled = YES;
        editImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:editImageView];
        [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self).offset(64);
            make.bottom.equalTo(self).offset(-64);
        }];
        self.editImageView = editImageView;
        
        
        [UIView animateWithDuration:0.1 animations:^{
            self.editImageView.transform = CGAffineTransformScale(self.editImageView.transform, 0.95, 0.95);
        } completion:^(BOOL finished) {
            self.overView.frame = (CGRect){self.overView.frame.origin,[self caculateOverviewSize]};
            self.overView.center = self.editImageView.center;
            [self addSubview:self.overView];
            self.squareView.frame = self.overView.bounds;
            [self.overView addSubview:self.squareView];
            [self drawCutPath];
        }];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint locationPointInsquareView = [[touches anyObject] locationInView:self.squareView];
    CGFloat squareViewW = CGRectGetWidth(self.squareView.frame);
    CGFloat squareViewH = CGRectGetHeight(self.squareView.frame);
    self.cutOperation = EDDrawCutViewOperrationMoveCenter;
    if (locationPointInsquareView.x < marginForLine) {
        self.cutOperation |= EDDrawCutViewOperrationMoveLeftLine;
    }
    if (locationPointInsquareView.x > squareViewW - marginForLine){
        self.cutOperation |= EDDrawCutViewOperrationMoveRightLine;
    }
    if (locationPointInsquareView.y < marginForLine){
        self.cutOperation |= EDDrawCutViewOperrationMoveTopLine;
    }
    if(locationPointInsquareView.y > squareViewH - marginForLine){
        self.cutOperation |= EDDrawCutViewOperrationMoveBottomLine;
    }
}

-(void)squarePanGestureHanele:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint locationPoint = [panGesture locationInView:self.overView];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            startPoint = locationPoint;
            self.panStartPoint = startPoint;
            self.beforeOringalCenter = self.squareView.center;
            self.beforeOringalFrame = self.squareView.frame;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat squareViewW = CGRectGetWidth(self.beforeOringalFrame);
            CGFloat squareViewH = CGRectGetHeight(self.beforeOringalFrame);
            CGFloat squareViewX = CGRectGetMinX(self.beforeOringalFrame);
            CGFloat squareViewY = CGRectGetMinY(self.beforeOringalFrame);
            CGFloat overViewW = CGRectGetWidth(self.overView.frame);
            CGFloat overViewH = CGRectGetHeight(self.overView.frame);
            CGFloat offsetY = locationPoint.y - self.panStartPoint.y;
            CGFloat offsetX = locationPoint.x - self.panStartPoint.x;

            if (self.cutOperation == EDDrawCutViewOperrationMoveCenter) {
                CGFloat centerX = locationPoint.x + (self.beforeOringalCenter.x - self.panStartPoint.x);
                CGFloat centerY = locationPoint.y + (self.beforeOringalCenter.y - self.panStartPoint.y);
                //边缘检测
                if (centerX - squareViewW / 2 < 0) {
                    centerX = squareViewW / 2;
                }
                if (centerX + squareViewW / 2 > overViewW) {
                    centerX = overViewW - squareViewW / 2;
                }
                if (centerY - squareViewH / 2 < 0) {
                    centerY = squareViewH / 2;
                }
                if (centerY + squareViewH / 2 > overViewH) {
                    centerY = overViewH - squareViewH / 2;
                }
                self.squareView.center = CGPointMake(centerX, centerY);
            }else{
                CGRect squareViewFrame = self.beforeOringalFrame;
                
                if (self.cutOperation & EDDrawCutViewOperrationMoveLeftLine) {
                    if (squareViewX + offsetX < 0) {
                        offsetX = - squareViewX;
                    }
                    if (squareViewW - offsetX < minWidthForCut) {
                        offsetX = squareViewW - minWidthForCut;
                    }
                    squareViewFrame = CGRectMake(CGRectGetMinX(squareViewFrame) + offsetX, CGRectGetMinY(squareViewFrame), CGRectGetWidth(squareViewFrame) - offsetX, CGRectGetHeight(squareViewFrame));
                    
                }
                if (self.cutOperation & EDDrawCutViewOperrationMoveRightLine){
                    
                    if (squareViewX + squareViewW + offsetX > overViewW) {
                        offsetX = overViewW - squareViewX -  squareViewW;
                    }
                    if (squareViewW + offsetX < minWidthForCut) {
                        offsetX = minWidthForCut - squareViewW;
                    }
                    squareViewFrame = CGRectMake(CGRectGetMinX(squareViewFrame), CGRectGetMinY(squareViewFrame), CGRectGetWidth(squareViewFrame) + offsetX, CGRectGetHeight(squareViewFrame));
                }
                if (self.cutOperation & EDDrawCutViewOperrationMoveTopLine){
                    if (squareViewY + offsetY < 0) {
                        offsetY = - squareViewY;
                    }
                    if (squareViewH - offsetY < minHeightForCut) {
                        offsetY = squareViewH - minHeightForCut;
                    }
                    squareViewFrame = CGRectMake(CGRectGetMinX(squareViewFrame) , CGRectGetMinY(squareViewFrame) + offsetY, CGRectGetWidth(squareViewFrame) ,CGRectGetHeight(squareViewFrame) - offsetY);
                }
                if(self.cutOperation & EDDrawCutViewOperrationMoveBottomLine){
                    if (squareViewY + squareViewH + offsetY > overViewH) {
                        offsetY = overViewH -squareViewH - squareViewY;
                    }
                    if (squareViewH + offsetY < minHeightForCut) {
                        offsetY = minHeightForCut - squareViewH;
                    }
                    squareViewFrame = CGRectMake(CGRectGetMinX(squareViewFrame), CGRectGetMinY(squareViewFrame), CGRectGetWidth(squareViewFrame), CGRectGetHeight(squareViewFrame) + offsetY);
                }
                self.squareView.frame = squareViewFrame;
            }
            [self drawCutPath];

        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}
- (CGSize)caculateOverviewSize
{
    CGFloat imageW = self.editImageView.image.size.width;
    CGFloat imageH = self.editImageView.image.size.height;
    CGFloat imageViewW = CGRectGetWidth(self.editImageView.frame);
    CGFloat imageViewH = CGRectGetHeight(self.editImageView.frame);
    CGFloat fator = 0.0;
    
    if (imageW / imageH < imageViewW / imageViewH) {
        fator = imageViewH / imageH;
    }else{
        fator = imageViewW / imageW;
    }
    CGFloat w = imageW * fator;
    CGFloat h = imageH *fator;
    return CGSizeMake(w, h);
}
//绘制裁剪框
-(void)drawCutPath{

    CGRect currentSquareCutRect = self.squareView.frame;
    CGFloat squareViewW = CGRectGetWidth(self.squareView.frame);
    CGFloat squareViewH = CGRectGetHeight(self.squareView.frame);
    self.lineArray[0].frame = CGRectMake(squareViewW / 3, 0, 1, squareViewH);
    self.lineArray[1].frame = CGRectMake(squareViewW / 3 * 2, 0, 1, squareViewH);
    self.lineArray[2].frame = CGRectMake(0, squareViewH / 3, squareViewW, 1);
    self.lineArray[3].frame = CGRectMake(0, squareViewH / 3 * 2, squareViewW, 1);
    
    
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.overView.frame), CGRectGetHeight(self.overView.frame))];
    [path appendPath:[UIBezierPath bezierPathWithRect:currentSquareCutRect]];
    path.usesEvenOddFillRule = NO;
    self.cutShapeLayer.path = path.CGPath;
}
-(UIImage *)getCutImage
{
    UIImage * originalImage = self.editImageView.image;
    CGFloat width = CGRectGetWidth(self.overView.frame);
    CGFloat rationScale = (originalImage.size.width  / width /1.0);
    
    CGRect currentSquareCutRect = self.squareView.frame;

    CGFloat origX = CGRectGetMinX(currentSquareCutRect) * rationScale;
    CGFloat origY = CGRectGetMinY(currentSquareCutRect) * rationScale;
    CGFloat oriWidth = CGRectGetWidth(currentSquareCutRect) * rationScale;
    CGFloat oriHeight = CGRectGetHeight(currentSquareCutRect) * rationScale;
    
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    
//    UIBezierPath * squarePath = [UIBezierPath bezierPathWithRect:myRect];
    UIImage * clipImage = [originalImage imageByCropToRect:myRect];
    return clipImage;
}
#pragma mark - lazy method
- (UIView *)overView
{
    if (_overView == nil) {
        _overView = [UIView new];
        _overView.backgroundColor = [UIColor clearColor];
    }
    return _overView;
}
- (UIView *)squareView
{
    if (_squareView == nil) {
        _squareView = [UIView new];
        _squareView.layer.borderWidth = 2;
        _squareView.layer.borderColor = [UIColor whiteColor].CGColor;
        UIPanGestureRecognizer * squarePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(squarePanGestureHanele:)];
        [_squareView addGestureRecognizer:squarePanGesture];
        _squareView.backgroundColor = [UIColor clearColor];
        
        for (NSInteger i = 0; i < 4; i++) {
            UIView *lineView = [UIView new];
            lineView.backgroundColor = [UIColor whiteColor];
            [_squareView addSubview:lineView];
            [self.lineArray addObject:lineView];
        }
        
        UIImageView *topLeftIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ed_image_edit_crop_lt"]];
        UIImageView *topRightIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ed_image_edit_crop_rt"]];
        UIImageView *bottomRightIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ed_image_edit_crop_lb"]];
        UIImageView *bottomLeftIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ed_image_edit_crop_rb"]];
        
        [_squareView addSubview:topLeftIv];
        [_squareView addSubview:topRightIv];
        [_squareView addSubview:bottomRightIv];
        [_squareView addSubview:bottomLeftIv];
        
        [topLeftIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_squareView).offset(-2.5);
            make.top.equalTo(_squareView).offset(-2.5);
        }];
        [topRightIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_squareView).offset(-2.5);
            make.trailing.equalTo(_squareView).offset(2.5);
        }];
        [bottomRightIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_squareView).offset(2.5);
            make.leading.equalTo(_squareView).offset(-2.5);
        }];
        [bottomLeftIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_squareView).offset(2.5);
            make.trailing.equalTo(_squareView).offset(2.5);
        }];
    }
    return _squareView;
}
-(CAShapeLayer *)cutShapeLayer{
    if(nil == _cutShapeLayer){
        _cutShapeLayer = [CAShapeLayer layer];
        _cutShapeLayer.fillRule = kCAFillRuleEvenOdd;
        _cutShapeLayer.fillColor = [[UIColor blackColor] CGColor];
        _cutShapeLayer.opacity = 0.5;
        [self.overView.layer addSublayer:_cutShapeLayer];
    }
    return _cutShapeLayer;
}
- (NSMutableArray<UIView *> *)lineArray
{
    if (_lineArray == nil) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}
- (void)actionRestoreCut
{
}
- (void)actionCancelCut
{
    if ([self.delegate respondsToSelector:@selector(didDrawCutViewCancel:)]) {
        [self.delegate didDrawCutViewCancel:self];
    }
}
- (void)actionSureCut
{
    UIImage *clipImage = [self getCutImage];
    if ([self.delegate respondsToSelector:@selector(didDrawCutViewGetImage:cutView:)]) {
        [self.delegate didDrawCutViewGetImage:clipImage cutView:self];
    }
}
@end
