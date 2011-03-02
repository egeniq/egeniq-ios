#import <UIKit/UIKit.h>
#import "EFImageView.h"

@interface EFImageTableView : EFImageView {
	UITableView *tableView_;
	NSIndexPath *indexPathForSelectedImage_;
}

@property (nonatomic, copy) NSString *imageVersion;

- (void)selectImageAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)indexPathForSelectedImage;

@end