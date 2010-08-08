//
//  EFPhoto.h
//  Egeniq
//
//  Created by Peter C. Verhage on 06-08-10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFPhotoVersion.h"

@protocol EFPhoto <NSObject>

/**
 * The name of the photo.
 */
@property (nonatomic, assign) NSString* name;

/**
 * The caption of the photo.
 */
@property (nonatomic, assign) NSString* caption;

/**
 * Gets the exact size of one of the differently sized versions of the photo.
 */
- (CGSize)sizeForVersion:(EFPhotoVersion)version;

/**
 * Gets the path of one of the differently sized versions of the photo.
 */
- (NSString*)pathForVersion:(EFPhotoVersion)version;

@end
