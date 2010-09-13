#import <UIKit/UIKit.h>
#import "EFPhotoView.h"

@interface EFPhotoScrollView : EFPhotoView {
    UIScrollView *pagingScrollView;    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    NSIndexPath *indexPathForSelectedPhoto;

    int firstVisiblePageIndexBeforeRotation;
    CGFloat percentScrolledIntoFirstVisiblePage;	
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForSelectedPhoto;

@end




