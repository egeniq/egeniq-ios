#import <UIKit/UIKit.h>
#import "EFImageView.h"

typedef enum {
    EFImageScrollViewRenderModePlain,
    EFImageScrollViewRenderModeTiled
} EFImageScrollViewRenderMode;

@interface EFImageScrollView : EFImageView {
    UIScrollView *pagingScrollView;    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	
    NSIndexPath *indexPathForSelectedImage;
	
	NSUInteger firstVisiblePageIndex;
    CGFloat percentScrolledIntoFirstVisiblePage;	
}

@property(nonatomic, copy) NSString *imageVersion;
@property(nonatomic, copy) NSString *lowResolutionImageVersion;
@property(assign) EFImageScrollViewRenderMode renderMode;
@property(assign) CGSize tileSize;
@property(assign) NSUInteger levelsOfDetail;

- (void)selectImageAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedImage;

@end




