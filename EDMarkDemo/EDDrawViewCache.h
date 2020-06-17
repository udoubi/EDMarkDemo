//
//  EDDrawViewCache.h
//  EDMarkDemo
//
//  Created by ke on 2020/6/5.
//  Copyright © 2020 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EDDrawViewCache : NSObject

@property (nonatomic,strong) NSMutableArray *toolArray;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSMutableDictionary *blankDictionary;

@end

NS_ASSUME_NONNULL_END
