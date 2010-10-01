@class EFPhotoView;

@protocol EFPhotoViewDelegate <NSObject>

@optional

- (NSIndexPath *)photoView:(EFPhotoView *)photoView willSelectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoView:(EFPhotoView *)photoView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)photoView:(EFPhotoView *)photoView willDeselectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoView:(EFPhotoView *)photoView didDeselectPhotoAtIndexPath:(NSIndexPath *)indexPath;

@end
