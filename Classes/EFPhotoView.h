#import <UIKit/UIKit.h>

#import "EFPhoto.h"
#import "EFPhotoViewDataSource.h"
#import "EFPhotoViewDelegate.h"

@interface NSIndexPath (EFPhotoView) 

@property(readonly) NSUInteger photo;
@property(readonly) NSUInteger collection;

+ (NSIndexPath *)indexPathForPhoto:(NSUInteger)photo inCollection:(NSUInteger)collection;

@end

@interface EFPhotoView : UIView {
    id<EFPhotoViewDataSource> dataSource;
    id<EFPhotoViewDelegate> delegate;
}

@property(nonatomic, assign) id<EFPhotoViewDataSource> dataSource;
@property(nonatomic, assign) id<EFPhotoViewDelegate> delegate;

- (void)reloadData;


@end
