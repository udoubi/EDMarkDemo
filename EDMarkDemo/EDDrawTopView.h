//
//  EDDrawTopView.h
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN





@class EDDrawTopView;

@protocol EDDrawTopViewDelegate <NSObject>

- (void)drawViewdidActionCancel:(EDDrawTopView *)topView;
- (void)drawViewdidActionClear:(EDDrawTopView *)topView;
- (void)drawViewdidActionPreStep:(EDDrawTopView *)topView;
- (void)drawViewdidActionNextStep:(EDDrawTopView *)topView;
- (void)drawViewdidActionSure:(EDDrawTopView *)topView;


@end



@interface EDDrawTopView : UIView

@property (nonatomic,weak) id<EDDrawTopViewDelegate> delegate;

@property (nonatomic,strong) UIButton *preButton;
@property (nonatomic,strong) UIButton *nextButton;

@end

NS_ASSUME_NONNULL_END
