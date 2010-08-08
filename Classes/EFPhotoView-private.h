@class EFImageScrollView;

/**
 * Private methods for the EFPhotoView class.
 */
@interface EFPhotoView ()

- (void)initPagingScrollView;

- (void)configurePage:(EFImageScrollView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)tilePages;
- (EFImageScrollView *)dequeueRecycledPage;

- (UIImage *)imageAtIndex:(NSUInteger)index;


@end