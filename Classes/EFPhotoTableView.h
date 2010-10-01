#import <UIKit/UIKit.h>
#import "EFPhotoView.h"

@interface EFPhotoTableView : EFPhotoView {
	UITableView *tableView;
    NSIndexPath *indexPathForSelectedPhoto;	
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedPhoto;

@end
