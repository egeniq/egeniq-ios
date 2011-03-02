#import <UIKit/UIKit.h>
#import "EFImage.h"

@interface EFTilingView : UIView {
	id <EFImage> image_;
	NSString *version_;
	BOOL useTiles_;
}

- (id)initWithImage:(id <EFImage>)image version:(NSString *)version;
- (id)initWithImage:(id <EFImage>)image version:(NSString *)version tileSize:(CGSize)tileSize levelsOfDetail:(NSUInteger)levelsOfDetail;

@end