#import <UIKit/UIKit.h>
#import "EFPhoto.h"

@interface EFTilingView : UIView {
    id<EFPhoto> photo;
	EFPhotoVersion version;
}

- (id)initWithPhoto:(id<EFPhoto>)thePhoto version:(EFPhotoVersion)theVersion tileSize:(CGSize)tileSize levelsOfDetail:(NSUInteger)levelsOfDetail;

@end
