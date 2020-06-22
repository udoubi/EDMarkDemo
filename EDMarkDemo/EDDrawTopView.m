//
//  EDDrawTopView.m
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawTopView.h"
#import <Masonry.h>

@implementation EDDrawTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(actionSure) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:rightButton];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setImage:[UIImage imageNamed:@"ed_image_mark_clear_select"] forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"ed_image_mark_clear_select"] forState:UIControlStateSelected];
        [clearButton addTarget:self action:@selector(actionClear) forControlEvents:UIControlEventTouchUpInside];
        clearButton.hidden = YES;
        [self addSubview:clearButton];
        
        UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [preButton setImage:[UIImage imageNamed:@"ed_image_mark_pre"] forState:UIControlStateNormal];
        [preButton setImage:[UIImage imageNamed:@"ed_image_mark_pre_select"] forState:UIControlStateSelected];
        [preButton addTarget:self action:@selector(actionPreStep) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:preButton];
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setImage:[UIImage imageNamed:@"ed_image_mark_next"] forState:UIControlStateNormal];
        [nextButton setImage:[UIImage imageNamed:@"ed_image_mark_next_select"] forState:UIControlStateSelected];
        [nextButton addTarget:self action:@selector(actionNextStep) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.trailing.equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(-30);
        }];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(30);
        }];
        
        self.preButton = preButton;
        self.nextButton = nextButton;
    }
    return self;
}
- (void)actionCancel
{
    if ([self.delegate respondsToSelector:@selector(drawViewdidActionCancel:)]) {
        [self.delegate drawViewdidActionCancel:self];
    }
}
- (void)actionSure
{
    if ([self.delegate respondsToSelector:@selector(drawViewdidActionSure:)]) {
        [self.delegate drawViewdidActionSure:self];
    }

}
- (void)actionClear
{
    if ([self.delegate respondsToSelector:@selector(drawViewdidActionClear:)]) {
        [self.delegate drawViewdidActionClear:self];
    }

}
- (void)actionPreStep
{
    if ([self.delegate respondsToSelector:@selector(drawViewdidActionPreStep:)]) {
        [self.delegate drawViewdidActionPreStep:self];
    }

}
- (void)actionNextStep
{
    if ([self.delegate respondsToSelector:@selector(drawViewdidActionNextStep:)]) {
        [self.delegate drawViewdidActionNextStep:self];
    }

}
@end
