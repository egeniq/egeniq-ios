/*
     File: TilingView.m
 Abstract: Handles tile drawing and tile image loading.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "TilingView.h"
#import "FastTiledLayer.h"


@implementation TilingView
@synthesize annotates;

+ (Class)layerClass {
	return [FastTiledLayer class];
}

- (id)initWithImageName:(NSString *)name size:(CGSize)size
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)])) {
        imageName = [name retain];

        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
//        tiledLayer.levelsOfDetail = 4;
//        tiledLayer.levelsOfDetailBias = 2;		
//		tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
    }
    return self;
}

// iOS4 code, only works with UIKit being thread safe, see http://developer.apple.com/iphone/library/qa/qa2009/qa1637.html 
- (void)drawRect1:(CGRect)rect {
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
            UIImage *tile = [self tileForScale:scale row:row col:col];
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                         tileSize.width, tileSize.height);

            // if the tile would stick outside of our bounds, we need to truncate it so as to avoid
            // stretching out the partial tiles at the right and bottom edges
            tileRect = CGRectIntersection(self.bounds, tileRect);

            [tile drawInRect:tileRect];
            
            if (self.annotates) {
                [[UIColor whiteColor] set];
                CGContextSetLineWidth(context, 6.0 / scale);
                CGContextStrokeRect(context, tileRect);
            }
        }
    }
}


// iOS 3.2 compatible code starts from here
-(void)drawRect:(CGRect)r
{
    // UIView uses the existence of -drawRect: to determine if should allow its CALayer
    // to be invalidated, which would then lead to the layer creating a backing store and
    // -drawLayer:inContext: being called.
    // By implementing an empty -drawRect: method, we allow UIKit to continue to implement
    // this logic, while doing our real drawing work inside of -drawLayer:inContext:
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{   
    // Do all your drawing here. Do not use UIGraphics to do any drawing, use Core Graphics instead.
	
    // get the scale from the context by getting the current transform matrix, then asking for
    // its "a" component, which is one of the two scale components. We could also ask for "d".
    // This assumes (safely) that the view is being scaled equally in both dimensions.
    CGFloat scale = CGContextGetCTM(context).a;

    // The clip bounding box indicates the area of the context that
    // is being requested for rendering.
	CGRect rect = CGContextGetClipBoundingBox(context);
	
	NSLog(@"ctm = %@", NSStringFromCGAffineTransform(CGContextGetCTM(context)));
	NSLog(@"box = %@\n", NSStringFromCGRect(rect));	
    
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
            UIImage *tile = [self tileForScale:scale row:row col:col];
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                         tileSize.width, tileSize.height);

            // if the tile would stick outside of our bounds, we need to truncate it so as to avoid
            // stretching out the partial tiles at the right and bottom edges
            tileRect = CGRectIntersection(self.bounds, tileRect);

			//            [tile drawInRect:tileRect];
			

//			CGContextTranslateCTM(context, 0.0, tileRect.origin.y);
//			CGContextScaleCTM(context, 1.0, -1.0);	
			
//			CGContextTranslateCTM(context, -((tile.size.width*0.5)-(tileRect.size.width*0.5)), (tile.size.height*0.5)-(tileRect.size.height*0.5));
//			CGContextTranslateCTM(context, -((self.bounds.size.width*0.5)-(tileRect.size.width*0.5)), (self.bounds.size.height*0.5)-(tileRect.size.height*0.5));	
//			CGContextTranslateCTM(context, 0.0, tileRect.size.height);
//			CGContextScaleCTM(context, 1.0, -1.0);

//			CGContextTranslateCTM(context, -((tileRect.origin.x * 0.5) - (tileRect.size.width * 0.5)), (tileRect.origin.y * 0.5) - (tileRect.size.height * 0.5));
//			CGContextTranslateCTM(context, 0.0, tileRect.size.height);
//			CGContextScaleCTM(context, 1.0, -1.0);			
			
			// in an upright coordinate system
			CGContextTranslateCTM(context, CGRectGetMinX(tileRect),CGRectGetMaxY(tileRect));
			// scale to flip the coordinate system so that the y axis goes up the drawing canvas
			CGContextScaleCTM(context, 1.0, -1.0);
			// translate so the origin is offset by exactly the rect origin
			CGContextTranslateCTM(context, -(tileRect.origin.x), -(tileRect.origin.y));
			
			
			CGContextDrawImage(context, tileRect, tile.CGImage);

            
            /*if (self.annotates) {
                [[UIColor whiteColor] set];
                CGContextSetLineWidth(context, 6.0 / scale);
                CGContextStrokeRect(context, tileRect);
            }*/
        }
    }
	
}
// EOF iOS 3.2 compatible code starts from here

- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col
{
     // we use "imageWithContentsOfFile:" instead of "imageNamed:" here because we don't want UIImage to cache our tiles
    NSString *tileName = [NSString stringWithFormat:@"%@_%d_%d_%d", imageName, (int)(scale * 1000), col, row];
    NSString *path = [[NSBundle mainBundle] pathForResource:tileName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
