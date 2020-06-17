//
//  EDDrawPenView.h
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDDrawViewConstant.h"

NS_ASSUME_NONNULL_BEGIN


@class EDDrawPenView;

@protocol EDDrawPenViewDelegate <NSObject>

- (void)drawViewPenColorDidChange:(EDDrawPenColorType)colorType;
- (void)drawViewPenWidthDidChange:(EDDrawPenWidthType)widthType;


@end

@interface EDDrawPenView : UIView


@property (nonatomic,weak) id<EDDrawPenViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
