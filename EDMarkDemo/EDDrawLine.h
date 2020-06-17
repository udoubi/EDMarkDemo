//
//  EDDrawLine.h
//  EDMarkDemo
//
//  Created by ke on 2020/5/26.
//  Copyright © 2020 ke. All rights reserved.
//

#import "EDDrawTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface EDDrawLine : EDDrawTool


- (_Bool)isRotateByRotateCtx;
- (_Bool)isSupportGestureRotate;
- (id)getFeature;
- (void)setFeature:(id)arg1;
- (void)limitValidFeatrue;
- (void)finalize;
- (id)measureText;
- (_Bool)isDrawVaild;
- (void)drawContentHandle:(struct CGContext *)arg1;
- (void)drawContent:(struct CGContext *)arg1;
- (void)drawUp:(struct CGPoint)arg1;
- (void)drawMove:(struct CGPoint)arg1;
- (void)drawDown:(struct CGPoint)arg1;
- (void)stopMoveHandle;
- (void)moveByOffset:(struct CGSize)arg1 endPoint:(struct CGPoint)arg2;
- (_Bool)testHitOnHandle:(struct CGPoint)arg1;
- (_Bool)hitOnHandle:(struct CGPoint)arg1;
- (_Bool)hitTest:(struct CGPoint)arg1;
- (void)setDrawType:(unsigned long long)arg1;


@end

NS_ASSUME_NONNULL_END
