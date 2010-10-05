/**
 * Image zoom view. 
 * 
 * Based on PhotoScroller example, Copyright (c) 2010 Apple Inc. All Rights Reserved.
 */

#import <UIKit/UIKit.h>
#import "EFTilingView.h";

@interface EFImageZoomView : UIScrollView <UIScrollViewDelegate> {
	UIView *contentView;
    EFTilingView *imageView;
	UIImageView *backgroundImageView;
    NSUInteger index;
	NSTimer *timer;
}
@property (assign) NSUInteger index;

- (void)displayImage:(NSString *)imagePath backgroundImage:(NSString *)backgroundImagePath size:(CGSize)size;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end