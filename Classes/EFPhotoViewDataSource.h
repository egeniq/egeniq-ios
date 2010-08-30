@class EFPhotoView;
@protocol EFPhoto;

@protocol EFPhotoViewDataSource

@required

- (NSUInteger)photoView:(EFPhotoView *)photoView numberOfPhotosInCollection:(NSUInteger)collection;
- (id<EFPhoto>)photoView:(EFPhotoView *)photoView photoAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSUInteger)numberOfCollectionsInPhotoView:(EFPhotoView *)photoView;


@end
