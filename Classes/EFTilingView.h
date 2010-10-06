#import <UIKit/UIKit.h>
#import "EFImage.h"

@interface EFTilingView : UIView {
    id<EFImage> image;
	NSString *version;
}

- (id)initWithImage:(id<EFImage>)theImage version:(NSString *)theVersion tileSize:(CGSize)tileSize levelsOfDetail:(NSUInteger)levelsOfDetail;

@end
