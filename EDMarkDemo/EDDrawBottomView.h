//
//  EDDrawBottomView.h
//  EDMarkDemo
//
//  Created by ke on 2020/6/3.
//  Copyright © 2020 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDDrawViewConstant.h"

NS_ASSUME_NONNULL_BEGIN



@class EDDrawBottomView;

@protocol EDDrawBottomViewDelegate <NSObject>

- (void)drawViewToolTypeDidChange:(EDDrawViewToolType)type;
- (void)didDrawViewDeleteTool:(EDDrawBottomView *)bottomView;


@end




@interface EDDrawBottomView : UIView

@property (nonatomic,weak) id<EDDrawBottomViewDelegate> delegate;

- (void)startEditStyle;
- (void)endEditStyle;
@end

NS_ASSUME_NONNULL_END
