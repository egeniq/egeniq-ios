@class EFImageView;

@protocol EFImageViewDataSource <NSObject>

@required

- (NSUInteger)imageView:(EFImageView *)imageView numberOfImagesInCollection:(NSUInteger)collection;
- (id<EFImage>)imageView:(EFImageView *)imageView imageAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSUInteger)numberOfCollectionsInImageView:(EFImageView *)imageView;


@end
