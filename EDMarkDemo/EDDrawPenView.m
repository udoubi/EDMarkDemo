//
//  EDDrawPenView.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawPenView.h"
#import "EDDrawDotButton.h"
#import <Masonry.h>
#import "UIColor+Addition.h"

@interface EDDrawPenView()

@property (nonatomic,strong) NSMutableArray *colorBtnArray;
@property (nonatomic,strong) NSMutableArray *widthBtnArray;
@property (nonatomic,assign) BOOL colorExpand;
@property (nonatomic,assign) BOOL widthExpand;

@end

@implementation EDDrawPenView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        EDDrawDotButton *red = [self colorButtonWithColor:[UIColor colorWithHex:0xFA5151]];
        red.selected = YES;
        [self.colorBtnArray addObject:red];
        
        EDDrawDotButton *green = [self colorButtonWithColor:[UIColor colorWithHex:0x3DCF52]];
        [self.colorBtnArray addObject:green];
        
        EDDrawDotButton *orange = [self colorButtonWithColor:[UIColor colorWithHex:0xF5A623]];
        [self.colorBtnArray addObject:orange];
        
        EDDrawDotButton *blue = [self colorButtonWithColor:[UIColor colorWithHex:0x4991E1]];
        [self.colorBtnArray addObject:blue];
        
        EDDrawDotButton *white = [self colorButtonWithColor:[UIColor colorWithHex:0xFFFFFF]];
        [self.colorBtnArray addObject:white];
        

        
        [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:button];
            button.hidden = !button.selected;
            [button addTarget:self action:@selector(actionSelectColor:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self).offset(1.5 * (26 + 32) - (26 + 32) * 2.5);
                make.size.mas_equalTo(CGSizeMake(32, 32));
        
            }];
        }];
        
        EDDrawDotButton *w3 = [self widthButtonWithWidth:3];
        [self.widthBtnArray addObject:w3];
        
        EDDrawDotButton *w6 = [self widthButtonWithWidth:6];
        [self.widthBtnArray addObject:w6];
   
        EDDrawDotButton *w9 = [self widthButtonWithWidth:9];
        w9.selected = YES;
        [self.widthBtnArray addObject:w9];
        
        EDDrawDotButton *w12 = [self widthButtonWithWidth:12];
        [self.widthBtnArray addObject:w12];
        
        EDDrawDotButton *w16 = [self widthButtonWithWidth:16];
        [self.widthBtnArray addObject:w16];
        

        [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:button];
            button.hidden = !button.selected;
            [button addTarget:self action:@selector(actionSelectWidth:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self).offset(3.5 * (26 + 32) - (26 + 32) * 2.5);
                make.size.mas_equalTo(CGSizeMake(32, 32));
        
            }];
        }];
    }
    return self;
}
- (void)actionSelectColor:(EDDrawDotButton *)sender
{
    if (!_colorExpand) {
        
        if (_widthExpand) {
            _widthExpand = NO;
        }
        [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            
            button.hidden = NO;
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).mas_offset(idx * (26 + 32) - (26 + 32) * 2.5);
            }];
        }];
        
        [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).mas_offset(5 * (26 + 32) - (26 + 32) * 2.5);
            }];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!button.selected) {
                    button.hidden = YES;
                }
            }];
        }];
        
    }else{
        
        [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

            if (idx == sender.tag) {
                button.selected = YES;
                if ([self.delegate respondsToSelector:@selector(drawViewPenColorDidChange:)]) {
                    [self.delegate drawViewPenColorDidChange:(EDDrawPenColorType)button.tag];
                }
            }else{
                button.selected = NO;
            }
            
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).mas_offset(1.5 * (26 + 32) - (26 + 32) * 2.5);
            }];
        }];
        
        [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

             if (button.selected) {
                 button.hidden = NO;
             }else{
                 button.hidden = YES;
             }
             
             [button mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.centerX.equalTo(self).mas_offset(3.5 * (26 + 32) - (26 + 32) * 2.5);
             }];
         }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

                if (idx == sender.tag) {
                    button.hidden = NO;
                }else{
                    button.hidden = YES;
                }
            }];
        }];
        
    }
    _colorExpand = !_colorExpand;
}
- (void)actionSelectWidth:(EDDrawDotButton *)sender
{
    if (!_widthExpand) {
        
        if (_colorExpand) {
            _colorExpand = NO;
        }
        [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).mas_offset(0 * (26 + 32) - (26 + 32) * 2.5);
            }];
        }];
        
        
        [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            
            button.hidden = NO;
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).mas_offset((idx  + 1)* (26 + 32) - (26 + 32) * 2.5);
            }];
        }];
  
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!button.selected) {
                    button.hidden = YES;
                }
            }];
        }];
        
    }else{
        [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

            if (idx == sender.tag) {
                button.selected = YES;
                if ([self.delegate respondsToSelector:@selector(drawViewPenWidthDidChange:)]) {
                    [self.delegate drawViewPenWidthDidChange:(EDDrawPenWidthType)button.tag];
                }
            }else{
                button.selected = NO;
            }
            
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).mas_offset(3.5 * (26 + 32) - (26 + 32) * 2.5);
            }];
        }];
        [self.colorBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

             if (button.selected) {
                 button.hidden = NO;
             }else{
                 button.hidden = YES;
             }
             
             [button mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.centerX.equalTo(self).mas_offset(1.5 * (26 + 32) - (26 + 32) * 2.5);
             }];
         }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.widthBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {

                if (idx == sender.tag) {
                    button.hidden = NO;
                }else{
                    button.hidden = YES;
                }
            }];
        }];
    }
    _widthExpand = !_widthExpand;
}
- (EDDrawDotButton *)colorButtonWithColor:(UIColor *)color
{
    EDDrawDotButton *dot = [EDDrawDotButton new];
    dot.radius = 16;
    dot.color = color;
    dot.selected = NO;
    return dot;
}
- (EDDrawDotButton *)widthButtonWithWidth:(CGFloat)radius
{
    EDDrawDotButton *dot = [EDDrawDotButton new];
    dot.radius = radius;
    dot.color = [UIColor whiteColor];
    dot.selected = NO;
    return dot;
}

- (NSMutableArray *)colorBtnArray
{
    if (_colorBtnArray == nil) {
        _colorBtnArray = [NSMutableArray array];
    }
    return _colorBtnArray;
}
- (NSMutableArray *)widthBtnArray
{
    if (_widthBtnArray == nil) {
        _widthBtnArray = [NSMutableArray array];
    }
    return _widthBtnArray;
}
@end
