#import <UIKit/UIKit.h>
#import "EFPhotoView.h"

@interface EFPhotoTableView : EFPhotoView {
	UITableView *tableView;
    NSIndexPath *indexPathForSelectedPhoto;	
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForSelectedPhoto;

@end
