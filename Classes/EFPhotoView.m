#import "EFPhotoView.h"

/**
 * Note, UITableView indexPaths are compatible with EFPhotoView indexPaths
 * they just use different property names.
 */
@implementation NSIndexPath (EFPhotoView)

- (NSUInteger)photo {
	return self.row;
}

- (NSUInteger)collection {
	return self.section;
}

+ (NSIndexPath *)indexPathForPhoto:(NSUInteger)photo inCollection:(NSUInteger)collection {
	return [NSIndexPath indexPathForRow:photo inSection:collection];
}

@end


@implementation EFPhotoView

@synthesize dataSource;
@synthesize delegate;

- (void)reloadData {
    
}

@end
