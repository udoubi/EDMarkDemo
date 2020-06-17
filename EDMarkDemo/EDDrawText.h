//
//  EDDrawText.h
//  EDMarkDemo
//
//  Created by ke on 2020/5/27.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface EDDrawText : EDDrawTool


@property (nonatomic,strong) NSString *content;

@property (nonatomic,assign) CGSize textBoundingSize;

- (CGPoint)getStartPoint;

@end

NS_ASSUME_NONNULL_END
