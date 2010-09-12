//
//  EFPhotoView.m
//  Egeniq
//
//  Created by Peter C. Verhage on 25-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EFPhotoScrollView.h"
#import "EFPhoto.h"
#import "EFPhotoVersion.h"
#import "EFImageZoomView.h"


/**
 * Private methods for the EFPhotoView class.
 */
@interface EFPhotoScrollView ()
 
- (CGSize)contentSizeForPagingScrollView;
- (void)configurePage:(EFImageZoomView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)tilePages;
- (EFImageZoomView *)dequeueRecycledPage;

- (NSUInteger)imageCount;
- (UIImage *)imageAtIndex:(NSUInteger)index;


@end

@implementation EFPhotoScrollView

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	
    if (self != nil) {
		// Step 1: make the outer paging scroll view
		CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
		pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
		pagingScrollView.pagingEnabled = YES;
		pagingScrollView.backgroundColor = [UIColor blackColor];
		pagingScrollView.showsVerticalScrollIndicator = NO;
		pagingScrollView.showsHorizontalScrollIndicator = NO;
		pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
		pagingScrollView.delegate = self;
		[self addSubview: pagingScrollView];
		
		// Step 2: prepare to tile content
		recycledPages = [[NSMutableSet alloc] init];
		visiblePages  = [[NSMutableSet alloc] init];
		[self tilePages];
    }
    
    return self;
}

- (void)dealloc {
	[pagingScrollView release];
    pagingScrollView = nil;
	[recycledPages release];
	recycledPages = nil;
	[visiblePages release];
	visiblePages = nil;
	[indexPathForSelectedPhoto release];
	indexPathForSelectedPhoto = nil;
	[super dealloc];	
}

- (void)layoutSubviews {
	if (pagingScrollView.frame.size.width != self.frame.size.width || 
		pagingScrollView.frame.size.height != self.frame.size.height) {
		// synchronize frame size
		pagingScrollView.frame = [self frameForPagingScrollView];
	
		// recalculate contentSize based on current orientation
		pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
		
		// adjust frames and configuration of each visible page
		for (EFImageZoomView *page in visiblePages) {
			CGPoint restorePoint = [page pointToCenterAfterRotation];
			CGFloat restoreScale = [page scaleToRestoreAfterRotation];
			page.frame = [self frameForPageAtIndex:page.index];
			[page setMaxMinZoomScalesForCurrentBounds];
			[page restoreCenterPoint:restorePoint scale:restoreScale];
		}
		
		// adjust contentOffset to preserve page location based on values collected prior to location
		CGFloat pageWidth = pagingScrollView.bounds.size.width;
		CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
		pagingScrollView.contentOffset = CGPointMake(newOffset, 0);	
	}
	
	[super layoutSubviews];
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages 
{
    // Calculate the content offset in case the orientation changes
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    } 	
	
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
    
    // Recycle no-longer-visible pages 
    for (EFImageZoomView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            EFImageZoomView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[EFImageZoomView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (EFImageZoomView *)dequeueRecycledPage {
    EFImageZoomView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (EFImageZoomView *page in visiblePages) {
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
    
    // Use tiled images
    // [page displayTiledImageNamed:[self imageNameAtIndex:index]
    //                        size:[self imageSizeAtIndex:index]];
    
    // To use full images instead of tiled images, replace the "displayTiledImageNamed:" call
    // above by the following line:
    [page displayImage:[self imageAtIndex:index]];
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10

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
    CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self imageCount], bounds.size.height);
}

#pragma mark -
#pragma mark Image wrangling

- (NSUInteger)imageCount {
	return dataSource == nil ? NSNotFound : [dataSource photoView:self numberOfPhotosInCollection:0];
}

- (UIImage *)imageAtIndex:(NSUInteger)index {
    id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:[NSIndexPath indexPathWithIndex:index]];    
    NSString *path = [photo pathForVersion: EFPhotoVersionOriginal];
    return [UIImage imageWithContentsOfFile: path];    
}


#pragma mark -
#pragma mark Photo view method overrides

- (void)setDataSource:(id<EFPhotoViewDataSource>)newDataSource {
    dataSource = newDataSource;
    [self reloadData];
}


- (void)reloadData {
	// Steap 1: clean-up
    for (EFImageZoomView *page in visiblePages) {
        [page removeFromSuperview];
    }	
	
	[recycledPages removeAllObjects];
	[visiblePages removeAllObjects];	
	
	// Step 2: prepare to tile content
	pagingScrollView.contentSize = [self contentSizeForPagingScrollView];	
	[self tilePages];
}

#pragma mark -
#pragma mark Photo scroll view specific public methods

- (NSIndexPath *)indexPathForSelectedPhoto {
    return indexPathForSelectedPhoto;
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath {
    indexPathForSelectedPhoto = [indexPath copy];
}

@end
