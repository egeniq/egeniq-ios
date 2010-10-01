//
//  EFPhoto.h
//  Egeniq
//
//  Created by Peter C. Verhage on 06-08-10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "EFPhotoVersion.h"

@protocol EFPhoto <NSObject>

@required

/**
 * Gets the exact size of one of the differently sized versions of the photo.
 */
- (CGSize)sizeForVersion:(EFPhotoVersion)version;

/**
 * Gets the path of one of the differently sized versions of the photo.
 */
- (NSString*)pathForVersion:(EFPhotoVersion)version;

@optional

/**
 * The name of the photo.
 */
@property (nonatomic, retain) NSString* name;

/**
 * The caption of the photo.
 */
@property (nonatomic, retain) NSString* caption;


@end
