//
//  EDDrawViewConstant.h
//  EDMarkDemo
//
//  Created by ke on 2020/6/4.
//  Copyright © 2020 ke. All rights reserved.
//

#ifndef EDDrawViewConstant_h
#define EDDrawViewConstant_h
#import "UIColor+Addition.h"

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
#endif


#define DEVICE_IS_IPHONE_X_SERIES ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
    if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {\
    isPhoneX = YES;\
    }\
}\
isPhoneX;\
})

// iPhone X
#define  ED_iPhoneX ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_HEIGHT == 375.f && SCREEN_WIDTH == 812.f) ? YES : NO)

// Status bar height.
//#define  ED_StatusBarHeight      (ED_iPhoneX ? 44.f : 20.f)
#define  ED_StatusBarHeight      (DEVICE_IS_IPHONE_X_SERIES ? 44.f : 20.f)

// Navigation bar height.
#define  ED_NavigationBarHeight  44.f

// Tabbar height.
//#define  ED_TabbarHeight         (ED_iPhoneX ? (49.f+34.f) : 49.f)
#define  ED_TabbarHeight         (DEVICE_IS_IPHONE_X_SERIES ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
//#define  ED_TabbarSafeBottomMargin         (ED_iPhoneX ? 34.f : 0.f)
#define  ED_TabbarSafeBottomMargin         (DEVICE_IS_IPHONE_X_SERIES ? 34.f : 0.f)

// Status bar & navigation bar height.
//#define  ED_StatusBarAndNavigationBarHeight  (ED_iPhoneX ? 88.f : 64.f)
#define  ED_StatusBarAndNavigationBarHeight  (DEVICE_IS_IPHONE_X_SERIES ? 88.f : 64.f)

typedef NS_ENUM(NSUInteger, EDDrawPenColorType) {
    EDDrawPenColorType_Red,
    EDDrawPenColorType_Green,
    EDDrawPenColorType_Orange,
    EDDrawPenColorType_Blue,
    EDDrawPenColorType_White
    
};
typedef NS_ENUM(NSUInteger, EDDrawPenWidthType) {
    EDDrawPenWidthType_W3,
    EDDrawPenWidthType_W6,
    EDDrawPenWidthType_W9,
    EDDrawPenWidthType_W12,
    EDDrawPenWidthType_W15
    
};
typedef NS_ENUM(NSUInteger, EDDrawViewToolType) {
    EDDrawViewToolType_Arrow,
    EDDrawViewToolType_Rect,
    EDDrawViewToolType_Line,
    EDDrawViewToolType_Text,
    EDDrawViewToolType_Rotate,
    EDDrawViewToolType_Cut,
    
};


static inline UIColor * getColorWithColorType(EDDrawPenColorType type){
    
    UIColor *color;
    switch (type) {
        case EDDrawPenColorType_Red:
            color = [UIColor colorWithHex:0xFA5151];
            break;
        case EDDrawPenColorType_Green:
            color = [UIColor colorWithHex:0x3DCF52];
            break;
        case EDDrawPenColorType_Orange:
            color = [UIColor colorWithHex:0xF5A623];
            break;
        case EDDrawPenColorType_Blue:
            color = [UIColor colorWithHex:0x4991E1];
            break;
        case EDDrawPenColorType_White:
            color = [UIColor colorWithHex:0xFFFFFF];
            break;
            
        default:
            break;
    }
    return color;
}
static inline UIFont * getFontSizeWithPenWithType(EDDrawPenWidthType type){
    
    UIFont *font;
    switch (type) {
        case EDDrawPenWidthType_W3:
            font = [UIFont systemFontOfSize:14];
            break;
        case EDDrawPenWidthType_W6:
            font = [UIFont systemFontOfSize:16];
            break;
        case EDDrawPenWidthType_W9:
            font = [UIFont systemFontOfSize:18];
            break;
        case EDDrawPenWidthType_W12:
            font = [UIFont systemFontOfSize:20];
            break;
        case EDDrawPenWidthType_W15:
            font = [UIFont systemFontOfSize:22];
            break;
            
        default:
            break;
    }
    return font;
}
static inline CGFloat getLineWithPenWithType(EDDrawPenWidthType type){
    
    CGFloat lineWidth;
    switch (type) {
        case EDDrawPenWidthType_W3:
            lineWidth = 2;
            break;
        case EDDrawPenWidthType_W6:
            lineWidth = 4;
            break;
        case EDDrawPenWidthType_W9:
            lineWidth = 6;
            break;
        case EDDrawPenWidthType_W12:
            lineWidth = 8;
            break;
        case EDDrawPenWidthType_W15:
            lineWidth = 10;
            break;
            
        default:
            break;
    }
    return lineWidth;
}
#endif /* EDDrawViewConstant_h */
