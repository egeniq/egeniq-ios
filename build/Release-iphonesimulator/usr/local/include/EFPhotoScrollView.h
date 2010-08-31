#import <UIKit/UIKit.h>
#import "EFPhotoView.h"

@interface EFPhotoScrollView : EFPhotoView <UIScrollViewDelegate> {
    UIScrollView *pagingScrollView;    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
    NSIndexPath *indexPathForSelectedPhoto;
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForSelectedPhoto;

@end




