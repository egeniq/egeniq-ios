#import <UIKit/UIKit.h>

#import "EFPhotoViewDataSource.h"
#import "EFPhotoViewDelegate.h"

@interface EFPhotoView : UIView {
    id<EFPhotoViewDataSource> dataSource;
    id<EFPhotoViewDelegate> delegate;
}

@property(nonatomic, assign) id<EFPhotoViewDataSource> dataSource;
@property(nonatomic, assign) id<EFPhotoViewDelegate> delegate;

- (void)reloadData;


@end
