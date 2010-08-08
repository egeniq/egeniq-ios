//
//  EFPhotoView.m
//  Egeniq
//
//  Created by Peter C. Verhage on 25-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EFPhotoView.h"
#import "EFPhotoView-private.h"
#import "EFPhoto.h"
#import "EFPhotoVersion.h"
#import "EFImageScrollView.h"


@implementation EFPhotoView

@synthesize photoModel, photoIndex;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame: frame])) {
        [self initPagingScrollView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder: coder])) {
        [self initPagingScrollView];
    }
    
    return self;

}

- (void)initPagingScrollView
{
    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.delegate = self;
    [self addSubview: pagingScrollView];
    
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
}

- (void)setPhotoModel:(id<EFPhotoModel>)newPhotoModel {
    photoModel = newPhotoModel;
    
    CGRect pagingScrollViewFrame = [pagingScrollView frame];
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width * [photoModel numberOfPhotos],
                                              pagingScrollViewFrame.size.height);
    [self tilePages];
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
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [photoModel numberOfPhotos] - 1);
    
    // Recycle no-longer-visible pages 
    for (EFImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            EFImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[EFImageScrollView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

- (EFImageScrollView *)dequeueRecycledPage
{
    EFImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (EFImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(EFImageScrollView *)page forIndex:(NSUInteger)index
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
#pragma mark  Frame calculations
#define PADDING 10

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
    return pageFrame;
}

#pragma mark -
#pragma mark Image wrangling

- (UIImage *)imageAtIndex:(NSUInteger)index {
    NSString * path = [[photoModel photoAtIndex: index] pathForVersion: EFPhotoVersionLarge];
    return [UIImage imageWithContentsOfFile: path];    
}

@end
