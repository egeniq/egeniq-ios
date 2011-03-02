#import <UIKit/UIKit.h>
#import "EFImageView.h"

typedef enum {
	EFImageScrollViewRenderModePlain,
	EFImageScrollViewRenderModeTiled
} EFImageScrollViewRenderMode;

@interface EFImageScrollView : EFImageView {
	UIScrollView *pagingScrollView_;
	NSMutableSet *recycledPages_;
	NSMutableSet *visiblePages_;

	NSIndexPath *indexPathForSelectedImage_;

	NSUInteger firstVisiblePageIndex_;
	CGFloat percentScrolledIntoFirstVisiblePage_;
    
    BOOL isAdjustingScrollFrame_;
}

@property (nonatomic, copy) NSString *imageVersion;
@property (nonatomic, copy) NSString *lowResolutionImageVersion;
@property (assign) EFImageScrollViewRenderMode renderMode;
@property (assign) CGSize tileSize;
@property (assign) NSUInteger levelsOfDetail;

- (void)selectImageAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedImage;

@end