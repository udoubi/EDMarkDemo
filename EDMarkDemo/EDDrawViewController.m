//
//  ViewController.m
//  EDMarkDemo
//
//  Created by ke on 2020/5/26.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawViewController.h"
#import "EDDrawView.h"
#import "EDDrawTopView.h"
#import "EDDrawPenView.h"
#import "EDDrawBottomView.h"
#import "EDDrawViewConstant.h"
#import <YYKit/YYKit.h>
#import "EDDrawViewCache.h"
#import "EDDrawCutView.h"
#import <Masonry/Masonry.h>

@interface EDDrawViewController ()<EDDrawTopViewDelegate,EDDrawPenViewDelegate,EDDrawBottomViewDelegate,EDDrawCutViewDelegate,EDDrawViewDelegate>


@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) EDDrawView *drawView;
@property (nonatomic,strong) EDDrawTopView *topView;
@property (nonatomic,strong) EDDrawBottomView *bottomView;
@property (nonatomic,strong) EDDrawPenView *penView;

@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) NSArray *widthArray;

@property (nonatomic,strong) NSMutableArray *cacheArray;
@property (nonatomic,assign) BOOL drawing;

@end

@implementation EDDrawViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.image = [UIImage imageNamed:@"IMG_20200523_113710.jpg"];
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44)];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.drawView = [EDDrawView new];
    self.drawView.backgroundColor = [UIColor clearColor];
    self.drawView.image = self.image;
    self.drawView.drawType = EDDrawViewToolType_Arrow;
    self.drawView.lineColor = getColorWithColorType(EDDrawPenColorType_Red);
    self.drawView.lineWidth = getLineWithPenWithType(EDDrawPenWidthType_W9);
    self.drawView.fontSize = getFontSizeWithPenWithType(EDDrawPenWidthType_W9);
    self.drawView.selectLineColor = [UIColor colorWithHex:0x8FC4FF];
    self.drawView.selectLineWidth = 2;
    self.drawView.delegate = self;
    [self.view addSubview:self.drawView];
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.topView = [EDDrawTopView new];
    self.topView.delegate = self;
    self.topView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.view);
        make.height.mas_equalTo(ED_StatusBarAndNavigationBarHeight - 20);
    }];
    
    self.penView = [EDDrawPenView new];
    self.penView.delegate = self;
    self.penView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.penView];
    [self.penView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-88 - ED_TabbarSafeBottomMargin);
        make.height.mas_equalTo(32);
    }];
    
    self.bottomView = [EDDrawBottomView new];
    self.bottomView.delegate = self;
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-17 - ED_TabbarSafeBottomMargin);
        make.height.mas_equalTo(36);
    }];
    [self addNotification];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUndoManagerDidUndoChangeNotification:) name:NSUndoManagerCheckpointNotification object:nil];
}
- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [self removeNotification];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (NSMutableArray *)cacheArray
{
    if (_cacheArray == nil) {
        _cacheArray = [NSMutableArray array];
    }
    return _cacheArray;
}
#pragma EDDrawTopViewDelegate

- (void)drawViewdidActionCancel:(EDDrawTopView *)topView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)drawViewdidActionSure:(EDDrawTopView *)topView
{
    UIImage *exportImage = [self exportImage];

}
- (void)drawViewdidActionClear:(EDDrawTopView *)topView
{
    [self.drawView actionClearCanvas];
    [self.drawView.undoManager removeAllActions];
    self.topView.preButton.selected = [self.drawView.undoManager canUndo];
    self.topView.nextButton.selected = [self.drawView.undoManager canRedo];
    [self.cacheArray removeAllObjects];
}
- (void)drawViewdidActionPreStep:(EDDrawTopView *)topView
{
    [self.drawView.undoManager undo];
}
- (void)drawViewdidActionNextStep:(EDDrawTopView *)topView
{
    [self.drawView.undoManager redo];
}
#pragma EDDrawPenViewDelegate

- (void)drawViewPenColorDidChange:(EDDrawPenColorType)colorType
{
    self.drawView.lineColor = getColorWithColorType(colorType);
    
}
- (void)drawViewPenWidthDidChange:(EDDrawPenWidthType)widthType
{
    self.drawView.lineWidth = getLineWithPenWithType(widthType);
    self.drawView.fontSize = getFontSizeWithPenWithType(widthType);
}
#pragma EDDrawBottomViewDelegate

- (void)drawViewToolTypeDidChange:(EDDrawViewToolType)type
{
    
    if (EDDrawViewToolType_Rotate == type) {
        
        [self drawViewRotateRight90];
        
    }else if (EDDrawViewToolType_Cut == type){
        [self drawViewStartCut];
    }else{
        self.drawView.drawType = type;
    }
}
- (void)didDrawViewDeleteTool:(EDDrawBottomView *)bottomView
{
    [self.drawView actionDeleteCurrentTool];
    [self.bottomView endEditStyle];
}
#pragma EDDrawCutViewDelegate
- (void)didDrawCutViewCancel:(EDDrawCutView *)cutView
{
    [cutView removeFromSuperview];
}
- (void)didDrawCutViewGetImage:(UIImage *)editImage cutView:(nonnull EDDrawCutView *)cutView
{
    
    self.drawView.image = editImage;
    self.imageView.image = editImage;
    [self.drawView actionClearCanvas];
    [self.drawView.undoManager removeAllActions];
    self.topView.preButton.selected = [self.drawView.undoManager canUndo];
    self.topView.nextButton.selected = [self.drawView.undoManager canRedo];
    [self.cacheArray removeAllObjects];
    [cutView removeFromSuperview];
}
#pragma EDDrawViewDelegate

- (void)didDrawViewStartHandingTool:(EDDrawView *)drawView
{
    [self.bottomView startEditStyle];
}
- (void)didDrawViewEndHandingTool:(EDDrawView *)drawView
{
    [self.bottomView endEditStyle];
}
- (void)didDrawTransformUpdate:(CGAffineTransform)transform
{
    [self.imageView.layer setAffineTransform:transform];
}
- (void)didDrawViewOnDrawing:(EDDrawView *)drawView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.alpha = 0.0;
        self.penView.alpha = 0.0;
        self.bottomView.alpha = 0.0;
    }];
    self.drawing = YES;
}
- (void)didDrawViewEndDrawing:(EDDrawView *)drawView
{
    if (self.drawing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                self.topView.alpha = 1.0;
                self.penView.alpha = 1.0;
                self.bottomView.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.drawing = NO;
            }];
        });
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.alpha = self.topView.alpha == 1.0 ? 0.0 : 1.0;
            self.penView.alpha = self.penView.alpha == 1.0 ? 0.0 : 1.0;
            self.bottomView.alpha = self.bottomView.alpha == 1.0 ? 0.0 : 1.0;
        }];
    }
}

- (void)drawViewRotateRight90
{
    [[self.drawView.undoManager prepareWithInvocationTarget:self] drawViewRotateLeft90];
    UIImage *exportImage = [self exportImage];
//    self.imageView.image = exportImage;
//    [self.view insertSubview:self.imageView aboveSubview:self.drawView];
    
    EDDrawViewCache *cache = [EDDrawViewCache new];
    cache.toolArray = self.drawView.toolArray.mutableCopy;
    cache.image = self.imageView.image;
    cache.blankDictionary = self.drawView.blankDictionary.mutableCopy;
    [self.cacheArray addObject:cache];
//    self.drawView.image = nil;
    [self.drawView.blankDictionary removeAllObjects];
    [self.drawView.toolArray removeAllObjects];
//
//    [UIView animateWithDuration:0.3 animations:^{
////        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_2);
////        self.imageView.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44);
//    } completion:^(BOOL finished) {
//
//    }];
    UIImage *retImage = [exportImage imageByRotateRight90];
    self.imageView.image = retImage;
    self.drawView.image = retImage;
    [self.drawView setNeedsDisplay];
}
- (void)drawViewRotateLeft90
{
    [[self.drawView.undoManager prepareWithInvocationTarget:self] drawViewRotateRight90];
    
    EDDrawViewCache *cache = self.cacheArray.lastObject;
    self.drawView.toolArray = cache.toolArray;
    self.imageView.image = cache.image;
    self.drawView.image = cache.image;
    self.drawView.blankDictionary = cache.blankDictionary;
    [self.cacheArray removeLastObject];
    [self.drawView setNeedsDisplay];
}
- (void)drawViewStartCut
{
    UIImage *exportImage = [self exportImage];
    EDDrawCutView *cutView = [[EDDrawCutView alloc] initWithEditImage:exportImage];
    cutView.delegate = self;
    cutView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cutView];
    [cutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (UIImage *)exportImage
{
    CGRect cutRect =  [self.drawView getExportImageRect];
    
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.drawView.frame.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    [self.drawView.layer renderInContext:context];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *retImage = [snap imageByCropToRect:cutRect];
    return retImage;;
}
- (void)handleUndoManagerDidUndoChangeNotification:(NSNotification *)nof
{
    self.topView.preButton.selected = [self.drawView.undoManager canUndo];
    self.topView.nextButton.selected = [self.drawView.undoManager canRedo];
}

@end
