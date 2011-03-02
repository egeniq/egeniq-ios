#import "EFTilingView.h"
#import "EFFastTiledLayer.h"

@interface EFTilingView ()
- (UIImage *)tileForScale:(CGFloat)scale row:(NSUInteger)row column:(NSUInteger)column;
@end

@implementation EFTilingView

+ (Class)layerClass {
	return [EFFastTiledLayer class];
}

- (id)initWithImage:(id <EFImage>)image version:(NSString *)version {
	CGSize size = [image sizeForVersion:version];

	self = [self initWithImage:image version:version tileSize:size levelsOfDetail:1];
	if (self != nil) {
		useTiles_ = NO;
	}

	return self;
}

- (id)initWithImage:(id <EFImage>)image version:(NSString *)version tileSize:(CGSize)tileSize levelsOfDetail:(NSUInteger)levelsOfDetail {
	CGSize size = [image sizeForVersion:version];

	if ((self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)])) {
		image_ = [image retain];
		version_ = [version copy];
		useTiles_ = YES;

		CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
		tiledLayer.levelsOfDetail = levelsOfDetail;
		tiledLayer.tileSize = tileSize;
	}

	return self;
}

/*
   // iOS4 code, only works with UIKit being thread safe, see http://developer.apple.com/iphone/library/qa/qa2009/qa1637.html
   - (void)drawRect:(CGRect)rect {
        CGContextRef context = UIGraphicsGetCurrentContext();

    // get the scale from the context by getting the current transform matrix, then asking for
    // its "a" component, which is one of the two scale components. We could also ask for "d".
    // This assumes (safely) that the view is being scaled equally in both dimensions.
    CGFloat scale = CGContextGetCTM(context).a;

    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;

    // Even at scales lower than 100%, we are drawing into a rect in the coordinate system of the full
    // image. One tile at 50% covers the width (in original image coordinates) of two tiles at 100%.
    // So at 50% we need to stretch our tiles to double the width and height; at 25% we need to stretch
    // them to quadruple the width and height; and so on.
    // (Note that this means that we are drawing very blurry images as the scale gets low. At 12.5%,
    // our lowest scale, we are stretching about 6 small tiles to fill the entire original image area.
    // But this is okay, because the big blurry image we're drawing here will be scaled way down before
    // it is displayed.)
    tileSize.width /= scale;
    tileSize.height /= scale;

    // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);

    for (int row = firstRow; row <= lastRow; row++) {
        for (int col = firstCol; col <= lastCol; col++) {
            UIImage *tile = [self tileForScale:scale row:row column:col];
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                         tileSize.width, tileSize.height);

            // if the tile would stick outside of our bounds, we need to truncate it so as to avoid
            // stretching out the partial tiles at the right and bottom edges
            tileRect = CGRectIntersection(self.bounds, tileRect);

            [tile drawInRect:tileRect];
        }
    }
   }
 */

// iOS 3.2 compatible code starts from here
- (void)drawRect:(CGRect)rect {
	// UIView uses the existence of -drawRect: to determine if should allow its CALayer
	// to be invalidated, which would then lead to the layer creating a backing store and
	// -drawLayer:inContext: being called.
	// By implementing an empty -drawRect: method, we allow UIKit to continue to implement
	// this logic, while doing our real drawing work inside of -drawLayer:inContext:
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
	// Do all your drawing here. Do not use UIGraphics to do any drawing, use Core Graphics instead.

	// get the scale from the context by getting the current transform matrix, then asking for
	// its "a" component, which is one of the two scale components. We could also ask for "d".
	// This assumes (safely) that the view is being scaled equally in both dimensions.
	CGFloat scale = roundf(CGContextGetCTM(context).a * 1000) / 1000;

	// The clip bounding box indicates the area of the context that
	// is being requested for rendering.
	CGRect rect = CGContextGetClipBoundingBox(context);

	CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
	CGSize tileSize = tiledLayer.tileSize;

	// Even at scales lower than 100%, we are drawing into a rect in the coordinate system of the full
	// image. One tile at 50% covers the width (in original image coordinates) of two tiles at 100%.
	// So at 50% we need to stretch our tiles to double the width and height; at 25% we need to stretch
	// them to quadruple the width and height; and so on.
	// (Note that this means that we are drawing very blurry images as the scale gets low. At 12.5%,
	// our lowest scale, we are stretching about 6 small tiles to fill the entire original image area.
	// But this is okay, because the big blurry image we're drawing here will be scaled way down before
	// it is displayed.)
	tileSize.width /= scale;
	tileSize.height /= scale;

	// calculate the rows and columns of tiles that intersect the rect we have been asked to draw
	int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
	int lastCol = floorf((CGRectGetMaxX(rect) - 1) / tileSize.width);
	int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
	int lastRow = floorf((CGRectGetMaxY(rect) - 1) / tileSize.height);

	for (int row = firstRow; row <= lastRow; row++) {
		for (int col = firstCol; col <= lastCol; col++) {
			UIImage *tile = [self tileForScale:scale row:row column:col];
			CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row, tileSize.width, tileSize.height);

			// if the tile would stick outside of our bounds, we need to truncate it so as to avoid
			// stretching out the partial tiles at the right and bottom edges
			tileRect = CGRectIntersection(self.bounds, tileRect);
			tileRect.size.width += 1; // TODO/FIXME, workaround for rounding problem
			tileRect.size.height += 1; // TODO/FIXME, workaround for rounding problem
			CGContextSaveGState(context);

			// in an upright coordinate system
			CGContextTranslateCTM(context, CGRectGetMinX(tileRect), CGRectGetMaxY(tileRect));

			// scale to flip the coordinate system so that the y axis goes up the drawing canvas
			CGContextScaleCTM(context, 1.0, -1.0);

			// translate so the origin is offset by exactly the rect origin
			CGContextTranslateCTM(context, -(tileRect.origin.x), -(tileRect.origin.y));

			// Enable these lines for debugging the rounding error (disable the draw image!)
			//CGContextSetRGBFillColor(context, 0.0, 50.0, 0.0, 1);
			//CGContextFillRect(context, tileRect);

			CGContextDrawImage(context, tileRect, tile.CGImage);

			CGContextRestoreGState(context);
		}
	}
}

// EOF iOS 3.2 compatible code

- (UIImage *)tileForScale:(CGFloat)scale row:(NSUInteger)row column:(NSUInteger)column {
	CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];

	NSString *path;
	if (useTiles_) {
		path = [image_ tilePathForVersion:version_ size:tiledLayer.tileSize scale:scale row:row column:column];
	} else {
		path = [image_ pathForVersion:version_];
	}

	UIImage *tile = [UIImage imageWithContentsOfFile:path];
	return tile;
}

@end