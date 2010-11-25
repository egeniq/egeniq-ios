@protocol EFImage < NSObject >

@required

/**
 * Gets the exact size of one of the differently sized versions of the image.
 */
- (CGSize)sizeForVersion:(NSString *)version;

/**
 * Gets the path of one of the differently sized versions of the image.
 */
- (NSString *)pathForVersion:(NSString *)version;

@optional

/**
 * Gets the path to a tile for one of the differently sized versions of the image.
 */
- (NSString *)tilePathForVersion:(NSString *)version size:(CGSize)size scale:(CGFloat)scale row:(NSUInteger)row column:(NSUInteger)column;

/**
 * The name of the image.
 */
@property (nonatomic, retain) NSString *name;

/**
 * The caption of the image.
 */
@property (nonatomic, retain) NSString *caption;

@end