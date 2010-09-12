/**
 * Image zoom view. 
 * 
 * Based on PhotoScroller example, Copyright (c) 2010 Apple Inc. All Rights Reserved.
 */

#import <UIKit/UIKit.h>

@interface EFImageZoomView : UIScrollView <UIScrollViewDelegate> {
    UIView        *imageView;
    NSUInteger     index;
}
@property (assign) NSUInteger index;

- (void)displayImage:(UIImage *)image;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end