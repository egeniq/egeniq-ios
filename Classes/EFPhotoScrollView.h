#import <UIKit/UIKit.h>
#import "EFPhotoView.h"

@interface EFPhotoScrollView : EFPhotoView {
    UIScrollView *pagingScrollView;    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
	
    NSIndexPath *indexPathForSelectedPhoto;
    CGFloat percentScrolledIntoFirstVisiblePage;	
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedPhoto;

@end




