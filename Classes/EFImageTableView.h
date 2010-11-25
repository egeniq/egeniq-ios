#import <UIKit/UIKit.h>
#import "EFImageView.h"

@interface EFImageTableView : EFImageView {
	UITableView *tableView;
	NSIndexPath *indexPathForSelectedImage;
}

@property (nonatomic, copy) NSString *imageVersion;

- (void)selectImageAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedImage;

@end