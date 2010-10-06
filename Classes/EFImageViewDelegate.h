@class EFImageView;

@protocol EFImageViewDelegate <NSObject>

@optional

- (NSIndexPath *)imageView:(EFImageView *)imageView willSelectImageAtIndexPath:(NSIndexPath *)indexPath;
- (void)imageView:(EFImageView *)imageView didSelectImageAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)imageView:(EFImageView *)imageView willDeselectImageAtIndexPath:(NSIndexPath *)indexPath;
- (void)imageView:(EFImageView *)imageView didDeselectImageAtIndexPath:(NSIndexPath *)indexPath;

@end
