typedef enum {
    EFPhotoVersionOriginal,
    EFPhotoVersionPad,
    EFPhotoVersionKey,
    EFPhotoVersionThumbnail,
	EFPhotoVersionNone
} EFPhotoVersion;

@protocol EFPhoto <NSObject>

@required

/**
 * Gets the exact size of one of the differently sized versions of the photo.
 */
- (CGSize)sizeForVersion:(EFPhotoVersion)version;

/**
 * Gets the path of one of the differently sized versions of the photo.
 */
- (NSString *)pathForVersion:(EFPhotoVersion)version;

@optional

/**
 * Gets the path to a tile for one of the differently sized versions of the photo.
 */
- (NSString *)tilePathForVersion:(EFPhotoVersion)version size:(CGSize)size  scale:(CGFloat)scale row:(NSUInteger)row column:(NSUInteger)column;

/**
 * The name of the photo.
 */
@property (nonatomic, retain) NSString *name;

/**
 * The caption of the photo.
 */
@property (nonatomic, retain) NSString *caption;


@end
