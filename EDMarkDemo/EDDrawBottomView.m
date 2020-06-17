//
//  EDDrawBottomView.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawBottomView.h"
#import "EDDrawDotButton.h"
#import <Masonry.h>

@interface EDDrawBottomView()


@property (nonatomic,strong) NSMutableArray *imageBtnArray;
@property (nonatomic,strong) UIButton *deleteButton;

@end

@implementation EDDrawBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        {
            EDDrawDotButton *button = [self buttonWithImage:[UIImage imageNamed:@"ed_image_mark_arrow"]];
            button.selected = YES;
            [self.imageBtnArray addObject:button];
        }
        {
            EDDrawDotButton *button = [self buttonWithImage:[UIImage imageNamed:@"ed_image_mark_rectangle"]];
            [self.imageBtnArray addObject:button];
        }
        {
            EDDrawDotButton *button = [self buttonWithImage:[UIImage imageNamed:@"ed_image_mark_line"]];
            [self.imageBtnArray addObject:button];
        }
        {
            EDDrawDotButton *button = [self buttonWithImage:[UIImage imageNamed:@"ed_image_mark_text"]];
            [self.imageBtnArray addObject:button];
        }
        {
            EDDrawDotButton *button = [self buttonWithImage:[UIImage imageNamed:@"ed_image_mark_rotate"]];
            [self.imageBtnArray addObject:button];
        }
        {
            EDDrawDotButton *button = [self buttonWithImage:[UIImage imageNamed:@"ed_image_mark_cut"]];
            [self.imageBtnArray addObject:button];
        }
        
        
        [self.imageBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:button];
            button.tag = idx;
            [button addTarget:self action:@selector(actionToolSelect:) forControlEvents:UIControlEventTouchUpInside];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(36, 36));
                make.centerX.equalTo(self).mas_offset(idx * (22 + 36) - (22 + 36) * 2.5);
                make.centerY.equalTo(self);
            }];
        }];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"ed_image_mark_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(actionDeleteTool) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.hidden = YES;
        [self addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        self.deleteButton = deleteButton;
    }
    return self;
}



- (void)actionToolSelect:(EDDrawDotButton *)sender
{
    
    if (sender.tag == 4 || sender.tag == 5) {
        if ([self.delegate respondsToSelector:@selector(drawViewToolTypeDidChange:)]) {
            [self.delegate drawViewToolTypeDidChange:(EDDrawViewToolType)sender.tag];
        }
    }else{
        [self.imageBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            if (button.tag == sender.tag) {
                button.selected = YES;
                if ([self.delegate respondsToSelector:@selector(drawViewToolTypeDidChange:)]) {
                    [self.delegate drawViewToolTypeDidChange:(EDDrawViewToolType)sender.tag];
                }
            }else{
                button.selected = NO;
            }
        }];
    }
}

- (void)actionDeleteTool
{
    if ([self.delegate  respondsToSelector:@selector(didDrawViewDeleteTool:)]) {
        [self.delegate didDrawViewDeleteTool:self];
    }
}

- (void)startEditStyle
{
    [self.imageBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.hidden = YES;
    }];
    self.deleteButton.hidden = NO;
}
- (void)endEditStyle
{
    [self.imageBtnArray enumerateObjectsUsingBlock:^(EDDrawDotButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.hidden = NO;
    }];
    self.deleteButton.hidden = YES;
}
- (EDDrawDotButton *)buttonWithImage:(UIImage *)image
{
    EDDrawDotButton *dot = [EDDrawDotButton new];
    dot.radius = 16;
    dot.image = image;
    dot.selected = NO;
    return dot;
}
- (NSMutableArray *)imageBtnArray
{
    if (_imageBtnArray == nil) {
        _imageBtnArray = [NSMutableArray array];
    }
    return _imageBtnArray;
}

@end
