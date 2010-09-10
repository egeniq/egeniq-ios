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

- (void)initPagingScrollView;

- (void)configurePage:(EFImageZoomView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)tilePages;
- (EFImageZoomView *)dequeueRecycledPage;

- (UIImage *)imageAtIndex:(NSUInteger)index;


@end

@implementation EFPhotoScrollView

- (id)initWithFrame:(CGRect)frame
{
	NSLog(@"initWithFrame");
    if ((self = [super initWithFrame: frame])) {
        [self initPagingScrollView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	NSLog(@"initWithCoder");
    if ((self = [super initWithCoder: coder])) {
        [self initPagingScrollView];
    }
    
    return self;

}



#pragma mark -
#pragma mark  Frame calculations
#define PADDING 10

- (CGRect)frameForPagingScrollViewWithFrame:(CGRect)frame {
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}


- (CGRect)frameForPagingScrollView {
    return [self frameForPagingScrollViewWithFrame:[[UIScreen mainScreen] bounds]];
}


- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
    return pageFrame;
}

- (void)initPagingScrollView
{
    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.delegate = self;
    [self addSubview: pagingScrollView];
	
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
}

- (void)reloadData {
    CGRect pagingScrollViewFrame = [pagingScrollView frame];
    NSUInteger count = [self.dataSource photoView:self numberOfPhotosInCollection:0];
    pagingScrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width * count, pagingScrollViewFrame.size.height);
    [self tilePages];
}

- (void)layoutSubviews {
	[super layoutSubviews];
/*    CGRect pagingScrollViewFrame = [self frameForPagingScrollViewWithFrame:[self bounds]];
    pagingScrollView.frame = pagingScrollViewFrame;
    NSUInteger count = [self.dataSource photoView:self numberOfPhotosInCollection:0];
    pagingScrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width * count, pagingScrollViewFrame.size.height);
	[self tilePages]; */
	
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	
    NSUInteger count = [self.dataSource photoView:self numberOfPhotosInCollection:0];
    lastNeededPageIndex  = MIN(lastNeededPageIndex, count - 1);
    
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

- (EFImageZoomView *)dequeueRecycledPage
{
    EFImageZoomView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (EFImageZoomView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(EFImageZoomView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    [page displayImage:[self imageAtIndex:index]];
}

#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}


#pragma mark -
#pragma mark Image wrangling

- (UIImage *)imageAtIndex:(NSUInteger)index {
    id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:[NSIndexPath indexPathWithIndex:index]];    
    NSString *path = [photo pathForVersion: EFPhotoVersionOriginal];
    return [UIImage imageWithContentsOfFile: path];    
}

- (void)setDataSource:(id<EFPhotoViewDataSource>)newDataSource {
    dataSource = newDataSource;
    [self reloadData];
}


- (NSIndexPath *)indexPathForSelectedPhoto {
    return indexPathForSelectedPhoto;
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath {
    indexPathForSelectedPhoto = [indexPath copy];
}

- (void)dealloc {
	[super dealloc];
	[pagingScrollView release];
    pagingScrollView = nil;
	[recycledPages release];
	recycledPages = nil;
	[visiblePages release];
	visiblePages = nil;
	[indexPathForSelectedPhoto release];
	indexPathForSelectedPhoto = nil;
}	

@end
