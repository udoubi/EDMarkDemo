//
//  DACircularProgressView.m
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "EDCircularProgressView.h"

#import <QuartzCore/QuartzCore.h>

@interface EDCircularProgressLayer : CALayer

@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic) CGFloat progress;

@end

@implementation EDCircularProgressLayer

@dynamic progressTintColor;
@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f;
    
    
    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat radians = radians = (float)((progress * 2.0f * M_PI) - M_PI_2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context,centerPoint.x, centerPoint.y, radius - 1, (float)(2.0f * M_PI), 0.0f, TRUE);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context,centerPoint.x, centerPoint.y, radius - 3, (float)(2.0f * M_PI), 0.0f, TRUE);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2].CGColor);
    CGContextAddArc(context,centerPoint.x, centerPoint.y, radius - 4, (float)(2.0f * M_PI), 0.0f, TRUE);
    CGContextFillPath(context);
    
    if (progress > 0.0f) {
        radius -= 4;
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(3.0f * M_PI_2), radians, NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
    }


}

@end

@interface EDCircularProgressView ()

@end

@implementation EDCircularProgressView

+ (void) initialize
{
    if (self == [EDCircularProgressView class]) {
        EDCircularProgressView *circularProgressViewAppearance = [EDCircularProgressView appearance];
        [circularProgressViewAppearance setProgressTintColor:[UIColor whiteColor]];
        [circularProgressViewAppearance setBackgroundColor:[UIColor clearColor]];
    }
}
+ (Class)layerClass
{
    return [EDCircularProgressLayer class];
}

- (EDCircularProgressLayer *)circularProgressLayer
{
    return (EDCircularProgressLayer *)self.layer;
}

- (id)init
{
    return [super initWithFrame:CGRectMake(0.0f, 0.0f, 56, 56)];
}

- (void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
    [self.circularProgressLayer setNeedsDisplay];
}


#pragma mark - Progress

- (CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self setProgress:progress animated:animated initialDelay:0.0];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
{
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    [self setProgress:progress
             animated:animated
         initialDelay:initialDelay
         withDuration:fabs(self.progress - pinnedProgress)];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
       withDuration:(CFTimeInterval)duration
{
    [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    [self.circularProgressLayer removeAnimationForKey:@"progress"];
    
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        animation.beginTime = CACurrentMediaTime() + initialDelay;
        animation.delegate = self;
        [self.circularProgressLayer addAnimation:animation forKey:@"progress"];
    } else {
        [self.circularProgressLayer setNeedsDisplay];
        self.circularProgressLayer.progress = pinnedProgress;
    }
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
   NSNumber *pinnedProgressNumber = [animation valueForKey:@"toValue"];
   self.circularProgressLayer.progress = [pinnedProgressNumber floatValue];
}


#pragma mark - UIAppearance methods


- (UIColor *)progressTintColor
{
    return self.circularProgressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}


@end
