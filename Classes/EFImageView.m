#import "EFImageView.h"

/**
 * Note, UITableView indexPaths are compatible with EFImageView indexPaths
 * they just use different property names.
 */
@implementation NSIndexPath (EFImageView)

- (NSUInteger)image {
	return self.row;
}

- (NSUInteger)collection {
	return self.section;
}

+ (NSIndexPath *)indexPathForImage:(NSUInteger)image inCollection:(NSUInteger)collection {
	return [NSIndexPath indexPathForRow:image inSection:collection];
}

@end


@implementation EFImageView

@synthesize dataSource;
@synthesize delegate;

- (void)reloadData {
    
}

@end
