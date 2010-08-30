@class EFPhotoView;

@protocol EFPhotoViewDelegate

@optional

- (NSIndexPath *)photoView:(EFPhotoView *)photoView willSelectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoView:(EFPhotoView *)photoView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)photoView:(EFPhotoView *)photoView willDeselectPhotoAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoView:(EFPhotoView *)photoView didDeselectPhotoAtIndePath:(NSIndexPath *)indexPath;

@end
