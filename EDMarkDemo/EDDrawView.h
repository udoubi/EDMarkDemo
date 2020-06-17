//
//  EDDrawView.h
//  Test
//
//  Created by ke on 2020/5/25.
//  Copyright © 2020 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDDrawViewConstant.h"

NS_ASSUME_NONNULL_BEGIN



@class EDDrawView;

@protocol EDDrawViewDelegate <NSObject>


- (void)didDrawViewStartHandingTool:(EDDrawView *)drawView;
- (void)didDrawViewEndHandingTool:(EDDrawView *)drawView;
- (void)didDrawTransformUpdate:(CGAffineTransform)transform;

- (void)didDrawViewBeginDrawing:(EDDrawView *)drawView;
- (void)didDrawViewOnDrawing:(EDDrawView *)drawView;
- (void)didDrawViewEndDrawing:(EDDrawView *)drawView;
@end



@interface EDDrawView : UIView

@property (nonatomic,strong) UIImage *image;


@property (nonatomic,weak) id<EDDrawViewDelegate> delegate;

@property (nonatomic,assign) EDDrawViewToolType drawType;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) UIFont *fontSize;

@property (nonatomic,strong) UIColor *selectLineColor;
@property (nonatomic,assign) CGFloat selectLineWidth;

@property (nonatomic,strong) NSMutableArray *toolArray;
@property (nonatomic,strong) NSMutableDictionary *blankDictionary;


- (void)actionDeleteCurrentTool;
- (void)actionClearCanvas;
- (CGRect)getExportImageRect;

@end

NS_ASSUME_NONNULL_END
