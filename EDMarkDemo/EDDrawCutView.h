//
//  EDDrawCutView.h
//  EDMarkDemo
//
//  Created by ke on 2020/6/5.
//  Copyright © 2020 ke. All rights reserved.
//

#import <UIKit/UIKit.h>




NS_ASSUME_NONNULL_BEGIN


@class EDDrawCutView;

@protocol EDDrawCutViewDelegate <NSObject>

- (void)didDrawCutViewGetImage:(UIImage *)editImage cutView:(EDDrawCutView *)cutView;
- (void)didDrawCutViewCancel:(EDDrawCutView *)cutView;

@end

@interface EDDrawCutView : UIView


@property (nonatomic,weak) id<EDDrawCutViewDelegate> delegate;
- (instancetype)initWithEditImage:(UIImage *)editImage;

@end

NS_ASSUME_NONNULL_END
