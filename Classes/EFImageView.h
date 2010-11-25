#import <UIKit/UIKit.h>

#import "EFImage.h"
#import "EFImageViewDataSource.h"
#import "EFImageViewDelegate.h"

@interface NSIndexPath (EFImageView)

@property (readonly) NSUInteger image;
@property (readonly) NSUInteger collection;

+ (NSIndexPath *)indexPathForImage:(NSUInteger)image inCollection:(NSUInteger)collection;

@end

@interface EFImageView : UIView {
}

@property (nonatomic, assign) id <EFImageViewDataSource> dataSource;
@property (nonatomic, assign) id <EFImageViewDelegate> delegate;

- (void)reloadData;

@end