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
@interface EFPhotoScrollView () <UIScrollViewDelegate>

- (void)configureScrollView;

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
	// Step 1: make the outer paging scroll view
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
	pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	pagingScrollView.pagingEnabled = YES;
	pagingScrollView.backgroundColor = [UIColor blackColor];
	pagingScrollView.showsVerticalScrollIndicator = NO;
	pagingScrollView.showsHorizontalScrollIndicator = NO;
	pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	pagingScrollView.delegate = self;
	[self addSubview:pagingScrollView];
	
	// Step 2: prepare to tile content
	recycledPages = [[NSMutableSet alloc] init];
	visiblePages  = [[NSMutableSet alloc] init];
	[self tilePages];
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
		CGFloat newOffset = (firstVisiblePageIndex * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
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

	firstVisiblePageIndex = 0;

    if (offset >= 0) {
		firstVisiblePageIndex = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndex * pageWidth)) / pageWidth;
    } else {
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
    [page displayImage:[self imageAtIndex:index]];
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Calculate index path for newly selected photo
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
	
	// Calculate new page index
	NSUInteger pageIndex = 0;
    if (offset >= 0) {
		pageIndex = floorf(offset / pageWidth);		
        CGFloat percentScrolled = (offset - (pageIndex * pageWidth)) / pageWidth;
		pageIndex = percentScrolled >= 0.5 ? pageIndex + 1 : pageIndex;
    } 		
	
	// Check if the new index path is different than the previous one
	NSIndexPath *indexPath = [NSIndexPath indexPathForPhoto:pageIndex inCollection:0];	
	if ([indexPath compare:indexPathForSelectedPhoto] == NSOrderedSame) {
		[self tilePages];
		return;
	}
	
	// Notify delegate that photo is going to be deselected
	if ([self.delegate respondsToSelector:@selector(photoView:willDeselectPhotoAtIndexPath:)]) {
		// We only currently support the selection of 1 photo, so we don't do anything with the return value
		[self.delegate photoView:self willDeselectPhotoAtIndexPath:indexPathForSelectedPhoto];
	}

	indexPathForSelectedPhoto = nil;
	
	// Notify delegate that photo is deselected
	if ([self.delegate respondsToSelector:@selector(photoView:didDeselectPhotoAtIndexPath:)]) {
		[self.delegate photoView:self didDeselectPhotoAtIndexPath:indexPathForSelectedPhoto];
	}
	
	// Notify delegate that we are going to select a different photo
	if ([self.delegate respondsToSelector:@selector(photoView:willSelectPhotoAtIndexPath:)]) {
		NSIndexPath *otherIndexPath = [self.delegate photoView:self willSelectPhotoAtIndexPath:indexPath];
		if (otherIndexPath != nil && [indexPath compare:otherIndexPath] != NSOrderedSame) {
			[self selectPhotoAtIndexPath:indexPath animated:YES];
			return;
		}
	}
	
	indexPathForSelectedPhoto = indexPath;
	[self tilePages];
	
	// Notify delegate that another photo has been selected
	if ([self.delegate respondsToSelector:@selector(photoView:didSelectPhotoAtIndexPath:)]) {
		[self.delegate photoView:self didSelectPhotoAtIndexPath:indexPath];
	}
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
    id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:[NSIndexPath indexPathForPhoto:index inCollection:0]];    
    NSString *path = [photo pathForVersion:EFPhotoVersionPad];
    return [UIImage imageWithContentsOfFile:path];    
}


#pragma mark -
#pragma mark Photo view method overrides

- (void)setDataSource:(id<EFPhotoViewDataSource>)newDataSource {
    [super setDataSource:newDataSource];
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
	
	
	// Notify delegate that we are going to select a different photo
	NSIndexPath *indexPath = [NSIndexPath indexPathForPhoto:0 inCollection:0];
	
	if ([self.delegate respondsToSelector:@selector(photoView:willSelectPhotoAtIndexPath:)]) {
		indexPath = [self.delegate photoView:self willSelectPhotoAtIndexPath:indexPath];
	}
	
	[self selectPhotoAtIndexPath:indexPath animated:NO];
	
	// Notify delegate that another photo has been selected
	if ([self.delegate respondsToSelector:@selector(photoView:didSelectPhotoAtIndexPath:)]) {
		[self.delegate photoView:self didSelectPhotoAtIndexPath:indexPath];
	}	
}

#pragma mark -
#pragma mark Photo scroll view specific public methods

- (NSIndexPath *)indexPathForSelectedPhoto {
    return [[indexPathForSelectedPhoto copy] autorelease];
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    indexPathForSelectedPhoto = [indexPath copy];

    CGFloat pageWidth = pagingScrollView.bounds.size.width;	
	CGFloat newOffset = (indexPathForSelectedPhoto.photo * pageWidth);

	if (animated) {
		[UIView beginAnimations:nil context:nil];	
		pagingScrollView.alpha = 0.0;
		[UIView commitAnimations];
	}
	
	pagingScrollView.contentOffset = CGPointMake(newOffset, 0);		
	[self tilePages];
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];	
		pagingScrollView.alpha = 1.0;	
		[UIView commitAnimations];
	}
}

@end
