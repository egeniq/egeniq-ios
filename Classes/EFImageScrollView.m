//
//  EFImageView.m
//  Egeniq
//
//  Created by Peter C. Verhage on 25-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EFImageScrollView.h"
#import "EFImage.h"
#import "EFImageZoomView.h"

/**
 * Private methods for the EFImageView class.
 */
@interface EFImageScrollView () < UIScrollViewDelegate >

- (void)configureScrollView;

- (CGSize)contentSizeForPagingScrollView;
- (void)configurePage:(EFImageZoomView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)tilePages;
- (EFImageZoomView *)dequeueRecycledPage;

- (NSUInteger)imageCount;

@end

@implementation EFImageScrollView

@synthesize imageVersion=imageVersion_, lowResolutionImageVersion=lowResolutionImageVersion_, renderMode=renderMode_, tileSize=tileSize_, levelsOfDetail=levelsOfDetail_;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self configureScrollView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self != nil) {
		[self configureScrollView];
	}
	return self;
}

- (void)configureScrollView {
	// Set some defaults
	self.imageVersion = nil;
	self.lowResolutionImageVersion = nil;
	self.renderMode = EFImageScrollViewRenderModePlain;
	self.tileSize = CGSizeMake(256.0, 256.0);
	self.levelsOfDetail = 3;

	// Step 1: make the outer paging scroll view
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	pagingScrollView_ = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	pagingScrollView_.pagingEnabled = YES;
	pagingScrollView_.backgroundColor = [UIColor blackColor];
	pagingScrollView_.showsVerticalScrollIndicator = NO;
	pagingScrollView_.showsHorizontalScrollIndicator = NO;
	pagingScrollView_.contentSize = [self contentSizeForPagingScrollView];
	pagingScrollView_.delegate = self;
	pagingScrollView_.bounces = NO;
	pagingScrollView_.alwaysBounceHorizontal = NO;
	[self addSubview:pagingScrollView_];

	// Step 2: prepare to tile content
	recycledPages_ = [[NSMutableSet alloc] init];
	visiblePages_ = [[NSMutableSet alloc] init];
	[self tilePages];
}

- (void)dealloc {
	[pagingScrollView_ release];
	pagingScrollView_ = nil;
	[recycledPages_ release];
	recycledPages_ = nil;
	[visiblePages_ release];
	visiblePages_ = nil;
	[indexPathForSelectedImage_ release];
	indexPathForSelectedImage_ = nil;
	[super dealloc];
}

- (void)layoutSubviews {
	if (pagingScrollView_.frame.size.width != self.frame.size.width ||
		pagingScrollView_.frame.size.height != self.frame.size.height) {
        isAdjustingScrollFrame_ = YES;
        
		// synchronize frame size
		pagingScrollView_.frame = [self frameForPagingScrollView];

		// recalculate contentSize based on current orientation
		pagingScrollView_.contentSize = [self contentSizeForPagingScrollView];

		// adjust frames and configuration of each visible page
		for (EFImageZoomView *page in visiblePages_) {
			CGPoint restorePoint = [page pointToCenterAfterRotation];
			CGFloat restoreScale = [page scaleToRestoreAfterRotation];
			page.frame = [self frameForPageAtIndex:page.index];
			[page setMaxMinZoomScalesForCurrentBounds];
			[page restoreCenterPoint:restorePoint scale:restoreScale];
		}
        
		// adjust contentOffset to preserve page location based on values collected prior to location
		CGFloat pageWidth = pagingScrollView_.bounds.size.width;
		CGFloat newOffset = (firstVisiblePageIndex_ * pageWidth) + (percentScrolledIntoFirstVisiblePage_ * pageWidth);
		pagingScrollView_.contentOffset = CGPointMake(newOffset, 0);
        
        isAdjustingScrollFrame_ = NO;            
	}

	[super layoutSubviews];
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages {
	// Calculate the content offset in case the orientation changes
	CGFloat offset = pagingScrollView_.contentOffset.x;
	CGFloat pageWidth = pagingScrollView_.bounds.size.width;

	firstVisiblePageIndex_ = 0;

	if (offset >= 0) {
		firstVisiblePageIndex_ = floorf(offset / pageWidth);
		percentScrolledIntoFirstVisiblePage_ = (offset - (firstVisiblePageIndex_ * pageWidth)) / pageWidth;
	} else {
		percentScrolledIntoFirstVisiblePage_ = offset / pageWidth;
	}

	// Calculate which pages are visible
	CGRect visibleBounds = pagingScrollView_.bounds;
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds));
	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, (int)[self imageCount] - 1);

	// Recycle no-longer-visible pages
	for (EFImageZoomView *page in visiblePages_) {
		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
			[recycledPages_ addObject:page];
			[page removeFromSuperview];
		}
	}
	[visiblePages_ minusSet:recycledPages_];

	// add missing pages
	for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
		if (![self isDisplayingPageForIndex:index]) {
			EFImageZoomView *page = [self dequeueRecycledPage];
			if (page == nil) {
				page = [[[EFImageZoomView alloc] init] autorelease];
			}
			[self configurePage:page forIndex:index];
			[pagingScrollView_ addSubview:page];
			[visiblePages_ addObject:page];
		}
	}
}

- (EFImageZoomView *)dequeueRecycledPage {
	EFImageZoomView *page = [recycledPages_ anyObject];
	if (page) {
		[[page retain] autorelease];
		[recycledPages_ removeObject:page];
	}
	return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
	BOOL foundPage = NO;
	for (EFImageZoomView *page in visiblePages_) {
		if (page.index == index) {
			foundPage = YES;
			break;
		}
	}
	return foundPage;
}

- (void)configurePage:(EFImageZoomView *)page forIndex:(NSUInteger)index {
	page.index = index;
	page.frame = [self frameForPageAtIndex:index];
	page.imageScrollView = self;
	[page displayImage:[NSIndexPath indexPathForImage:index inCollection:0]];
}

#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isAdjustingScrollFrame_) {
        return;
    }
    
	// Calculate index path for newly selected image
	CGFloat offset = pagingScrollView_.contentOffset.x;
 	CGFloat pageWidth = pagingScrollView_.bounds.size.width;

	// Calculate new page index
	NSUInteger pageIndex = 0;
	if (offset >= 0) {
		pageIndex = floorf(offset / pageWidth);
		CGFloat percentScrolled = (offset - (pageIndex * pageWidth)) / pageWidth;
		pageIndex = percentScrolled >= 0.5 ? pageIndex + 1 : pageIndex;
	}
 
	// Check if the new index path is different than the previous one
	NSIndexPath *indexPath = [NSIndexPath indexPathForImage:pageIndex inCollection:0];
	if ([indexPath compare:indexPathForSelectedImage_] == NSOrderedSame) {
		[self tilePages];
		return;
	}

	// Notify delegate that image is going to be deselected
	if ([self.delegate respondsToSelector:@selector(imageView:willDeselectImageAtIndexPath:)]) {
		// We only currently support the selection of 1 image, so we don't do anything with the return value
		[self.delegate imageView:self willDeselectImageAtIndexPath:indexPathForSelectedImage_];
	}

	indexPathForSelectedImage_ = nil;

	// Notify delegate that image is deselected
	if ([self.delegate respondsToSelector:@selector(imageView:didDeselectImageAtIndexPath:)]) {
		[self.delegate imageView:self didDeselectImageAtIndexPath:indexPathForSelectedImage_];
	}

	// Notify delegate that we are going to select a different image
	if ([self.delegate respondsToSelector:@selector(imageView:willSelectImageAtIndexPath:)]) {
		NSIndexPath *otherIndexPath = [self.delegate imageView:self willSelectImageAtIndexPath:indexPath];
		if (otherIndexPath != nil && [indexPath compare:otherIndexPath] != NSOrderedSame) {
			[self selectImageAtIndexPath:indexPath animated:YES];
			return;
		}
	}

	indexPathForSelectedImage_ = [indexPath retain];
	[self tilePages];

	// Notify delegate that another image has been selected
	if ([self.delegate respondsToSelector:@selector(imageView:didSelectImageAtIndexPath:)]) {
		[self.delegate imageView:self didSelectImageAtIndexPath:indexPath];
	}
}

#pragma mark -
#pragma mark Frame calculations
#define PADDING 10

- (CGRect)frameForPagingScrollView {
	CGRect frame = self.frame;
	frame.origin.x -= PADDING;
	frame.size.width += (2 * PADDING);
	return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
	// We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
	// landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
	// view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
	// because it has a rotation transform applied.
	CGRect bounds = pagingScrollView_.bounds;
	CGRect pageFrame = bounds;
	pageFrame.size.width -= (2 * PADDING);
	pageFrame.origin.x = (bounds.size.width * index) + PADDING;
	return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
	// We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
	CGRect bounds = pagingScrollView_.bounds;
	return CGSizeMake(bounds.size.width * [self imageCount], bounds.size.height);
}

#pragma mark -
#pragma mark Image wrangling

- (NSUInteger)imageCount {
	return self.dataSource == nil ? NSNotFound : [self.dataSource imageView:self numberOfImagesInCollection:0];
}

#pragma mark -
#pragma mark Image view method overrides

- (void)setDataSource:(id <EFImageViewDataSource>)newDataSource {
	[super setDataSource:newDataSource];
	[self reloadData];
}

- (void)reloadData {
	// Steap 1: clean-up
	for (EFImageZoomView *page in visiblePages_) {
		[page removeFromSuperview];
	}

	[recycledPages_ removeAllObjects];
	[visiblePages_ removeAllObjects];

	// Step 2: prepare to tile content
	pagingScrollView_.contentSize = [self contentSizeForPagingScrollView];

	// Notify delegate that we are going to select a different image
	NSIndexPath *indexPath = [NSIndexPath indexPathForImage:0 inCollection:0];

	if ([self.delegate respondsToSelector:@selector(imageView:willSelectImageAtIndexPath:)]) {
		indexPath = [self.delegate imageView:self willSelectImageAtIndexPath:indexPath];
	}

	[self selectImageAtIndexPath:indexPath animated:NO];

	// Notify delegate that another image has been selected
	if ([self.delegate respondsToSelector:@selector(imageView:didSelectImageAtIndexPath:)]) {
		[self.delegate imageView:self didSelectImageAtIndexPath:indexPath];
	}
}

#pragma mark -
#pragma mark Image scroll view specific public methods

- (NSIndexPath *)indexPathForSelectedImage {
	return [[indexPathForSelectedImage_ copy] autorelease];
}

- (void)selectImageAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
	indexPathForSelectedImage_ = [indexPath copy];

	CGFloat pageWidth = pagingScrollView_.bounds.size.width;
	CGFloat newOffset = (indexPathForSelectedImage_.image * pageWidth);

	if (animated) {
		[UIView beginAnimations:nil context:nil];
		pagingScrollView_.alpha = 0.0;
		[UIView commitAnimations];
	}

	pagingScrollView_.contentOffset = CGPointMake(newOffset, 0);
	[self tilePages];

	if (animated) {
		[UIView beginAnimations:nil context:nil];
		pagingScrollView_.alpha = 1.0;
		[UIView commitAnimations];
	}
}

@end