#import <UIKit/UIKit.h>
#import "EFPhotoView.h"

typedef enum {
    EFPhotoScrollViewRenderModePlain,
    EFPhotoScrollViewRenderModeTiled
} EFPhotoScrollViewRenderMode;

@interface EFPhotoScrollView : EFPhotoView {
    UIScrollView *pagingScrollView;    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	
    NSIndexPath *indexPathForSelectedPhoto;
	
	NSUInteger firstVisiblePageIndex;
    CGFloat percentScrolledIntoFirstVisiblePage;	
}

@property(assign) EFPhotoVersion imageVersion;
@property(assign) EFPhotoVersion lowResolutionImageVersion;
@property(assign) EFPhotoScrollViewRenderMode renderMode;
@property(assign) CGSize tileSize;
@property(assign) NSUInteger levelsOfDetail;

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedPhoto;

@end




