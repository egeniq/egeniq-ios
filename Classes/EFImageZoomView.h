/**
 * Image zoom view. 
 * 
 * Based on PhotoScroller example, Copyright (c) 2010 Apple Inc. All Rights Reserved.
 */

#import <UIKit/UIKit.h>
#import "EFTilingView.h"

@class EFPhotoScrollView;

@interface EFImageZoomView : UIScrollView <UIScrollViewDelegate> {
	UIView *contentView;
    EFTilingView *imageView;
	UIImageView *lowResolutionImageView;
}

@property(nonatomic, assign) EFPhotoScrollView *imageScrollView;
@property(assign) NSUInteger index;

- (void)displayImage:(NSIndexPath *)indexPath;
- (void)setMaxMinZoomScalesForCurrentBounds;

- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end