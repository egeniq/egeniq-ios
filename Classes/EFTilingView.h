#import <UIKit/UIKit.h>

@interface EFTilingView : UIView {
    NSString *imageName;
}

- (id)initWithImageName:(NSString *)name size:(CGSize)size;
- (UIImage *)tileForScale:(CGFloat)scale row:(int)row column:(int)column;

@end
